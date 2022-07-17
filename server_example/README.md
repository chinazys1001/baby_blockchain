# General info

An example of server node for [BabyBlockchain](https://github.com/chinazys1001/baby_blockchain).

The server gets triggered by a [cloud function](https://github.com/chinazys1001/baby_blockchain/blob/master/functions/index.js) each time new transactions were added to mempool using http POST method. On each request a new block is created and verified. If the block is valid, it is added to *blockHistory*, its transactions are added to *txDatabase* and the *mempool* is cleared up. 

The driver code can be found in [server.dart](https://github.com/chinazys1001/baby_blockchain/blob/master/server_example/bin/server.dart). The blockchain resources ([/blockchain](https://github.com/chinazys1001/baby_blockchain/tree/master/server_example/bin/blockchain) folder) and database-interation tools [/database](https://github.com/chinazys1001/baby_blockchain/tree/master/server_example/bin/database)] are copy-pasted from [lib/domain_layer/](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/domain_layer) and [lib/data_layer/](https://github.com/chinazys1001/baby_blockchain/tree/master/lib/data_layer) respectively. Full documentaion is available in [README](https://github.com/chinazys1001/baby_blockchain/blob/master/server_example/README.md). 

# Running the server

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
```

The expected output on each POST call from to the server (e.g. https://my-baby-blockchain-server.com/new-transaction):

```
getting mempool...
mempool is empty. leaving... // if there are currently no transactions in mempool
creating block... // if there is at least one transaction in mempool
validating block...
clearing up mempool...
block was successfully validated // if the block verification completed normally
```


## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

The expected output on each POST call from to the server (e.g. https://my-baby-blockchain-server.com/new-transaction):

```
getting mempool...
mempool is empty. leaving... // if there are currently no transactions in mempool
creating block... // if there is at least one transaction in mempool
validating block...
clearing up mempool...
block was successfully validated // if the block verification completed normally
```