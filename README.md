# Blockbook Docker

Docker container for Blockbook, the Trezor wallet backend. 

To run, just pass the RPC details (user, pass, rpc host, rpc port and zmq socket port) from your Bitcoin full node as env variables:

```
docker run --name blockbook -it -p 9030:9030 -p 9130:9130 -e RPC_USER=myuser -e RPC_PASS=pass -e RPC_HOST=10.1.2.3 -e  MQ_PORT=29000 gustavonalle/blockbook
```

It will start syncing and the progress can be checked at https://localhost:9130


## Stopping gracefully

To stop the container gracefully (and have the database files preserved), do a ```docker stop -t 60 blockbook``` and to restart it later, ```docker start blockbook```.

## Custom launcher

When using the command above to launch, the docker container will automatically generate the config file and will use sensible parameters to run Blockbook with Bitcoin.
If more control is desired, like using custom flags, custom configuration files, or using any shitcoin supported by Blockbook, just override the entrypoint:


```
 docker run -v $PWD/cfg:/home/blockbook/cfg -w=/home/blockbook/go/src/blockbook -it -p 9130:9130 -p 9030:9030 --entrypoint=/home/blockbook/go/src/blockbook/blockbook gustavonalle/blockbook -sync -blockchaincfg=/home/blockbook/cfg/cfg.json -workers=10  -logtostderr
```

The command above will run blockbook with 10 workers, using a custom configuration file called cfg.json, which will come from a volume mapping the local folder cfg to /home/blockbook/cfg inside the container. 
