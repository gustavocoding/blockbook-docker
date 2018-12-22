FROM fedora:29

MAINTAINER gustavonalle@gmail.com

ENV TAG=master

# Install dependencies 
RUN dnf -y install which libstdc++-devel zeromq zeromq-devel gcc-c++ findutils libstdc++-static golang \
                   snappy-devel zlib-devel bzip2-devel lz4-libs lz4-devel git && \
	     	   dnf clean all

RUN useradd -ms /bin/bash blockbook 

USER blockbook

RUN  mkdir -p $HOME/rocksdb/include 

ENV HOME=/home/blockbook
ENV GOPATH=$HOME/go
ENV PATH="$PATH:$GOPATH/bin"

# Install go dep
RUN mkdir -p $HOME/go && go get github.com/golang/dep/cmd/dep

# Install RocksDB and the Go wrapper

ENV CGO_CFLAGS="-I/$HOME/rocksdb/include"
ENV CGO_LDFLAGS="-L/$HOME/rocksdb -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4"

RUN cd /tmp && git clone https://github.com/facebook/rocksdb.git && cd rocksdb && CFLAGS=-fPIC CXXFLAGS=-fPIC make release && \
                cp librock* $HOME/rocksdb && cp -r include $HOME/rocksdb && \
                cd $HOME && rm -Rf /tmp/rocksdb && \
		go get github.com/tecbot/gorocksdb

# Build Blockbook
RUN cd $GOPATH/src && git clone https://github.com/trezor/blockbook.git && cd blockbook && git checkout $TAG && dep ensure -vendor-only && \
         BUILDTIME=$(date --iso-8601=seconds); GITCOMMIT=$(git describe --always --dirty); \ 
         LDFLAGS="-X blockbook/common.version=${TAG} -X blockbook/common.gitcommit=${GITCOMMIT} -X blockbook/common.buildtime=${BUILDTIME}" && \ 
         go build -ldflags="-s -w ${LDFLAGS}" && rm -Rf /home/blockbook/go/pkg/dep/sources
 
# Copy startup scripts
COPY launch.sh $HOME

COPY blockchain_cfg.json $HOME

EXPOSE 9030 9130

ENTRYPOINT $HOME/launch.sh
