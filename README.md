# Blockbook Docker

Docker container for Blockbook, the Trezor wallet backend. 

To run, just pass the RPC details (user, pass, host and port) from your full node as env variables:

```
docker run -it -e RPC_USER=myuser -e RPC_PASS=pass -e RPC_HOST=10.1.2.3 gustavonalle/blockbook
```

It will start syncing and the progress can be checked using: 

```
curl http://10.1.2.3:9030
```
