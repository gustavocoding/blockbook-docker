# Blockbook Docker

Docker container for Blockbook, the Trezor wallet backend. 

To run, just pass the RPC details (user, pass, host and port) from your full node as env variables:

```
docker run --name blockbook -it -p 9030:9030 -p 9130:9130 -e RPC_USER=myuser -e RPC_PASS=pass -e RPC_HOST=10.1.2.3  -ee MQ_PORT=29000 gustavonalle/blockbook
```

It will start syncing and the progress can be checked at https://localhost:9130


## Stopping gracefully

To stop the container gracefully (and have the database files preserved), do a ```docker stop blockbook``` and to restart it later, ```docker start blockbook```.

