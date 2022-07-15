import 'dart:async';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'blockchain/block.dart';
import 'blockchain/blockchain.dart';
import 'blockchain/transaction.dart';

// database
Firestore? firestore;

// configure routes
final _router = Router()..post('/new-transaction', _postTransactionHandler);

Future<Response> _postTransactionHandler(Request request) async {
  try {
    if (request.method == "POST") {
      _checkMempool();
      // Firestore.instance.collection("blockHistory").add({"oh wow": 21});
      return Response.ok('Accepted');
    } else {
      return Response.notFound("${request.method} method is not supported");
    }
  } catch (e) {
    return Response.badRequest(body: e.toString());
  }
}

void _checkMempool() async {
  try {
    // if server was asleep
    blockchain ??= await Blockchain.initBlockchain();
    firestore ??= Firestore.initialize("baby-blockchain");

    while (true) {
      print("getting mempool...");
      Set<Transaction> pendingTransactions =
          await blockchain!.mempool.getMempool();
      if (pendingTransactions.isEmpty) {
        print("mempool is empty. leaving...");
        return;
      }
      print("creating block...");
      Block newBlock = await Block.createBlock(pendingTransactions);

      print("validating block...");
      Map<int, dynamic>? error = await blockchain!.validateBlock(newBlock);

      // the block is valid
      if (error == null) {
        print("clearing up mempool...");
        // removing block transactions from mempool
        for (Transaction transaction in pendingTransactions) {
          await blockchain!.mempool.removeTransaction(transaction);
        }

        print("block was successfully validated");
        return;
      }

      // some database sync issue. should be fixed on next run automatically
      if (error.containsKey(1)) {
        print("prevHash != ID of the last block (1)");
      }

      // some invalid transaction
      if (error.containsKey(2) || error.containsKey(3)) {
        Transaction invalidTransaction = error.values.first;
        if (error.containsKey(2)) {
          print("invalid transaction (2): ${invalidTransaction.toString()}");
        }
        if (error.containsKey(3)) {
          print("invalid transaction (3): ${invalidTransaction.toString()}");
        }
        // removing it
        await blockchain!.mempool.removeTransaction(invalidTransaction);
      }

      // conflicting transactions with some robot
      if (error.containsKey(4)) {
        String robotID = error.values.first;
        print("conflicting transactions with robot (4): ID = $robotID");

        List<Transaction> conflictingTransactions = [];
        for (Transaction transaction in pendingTransactions) {
          if (transaction.operation.robotID == robotID) {
            conflictingTransactions.add(transaction);
          }
        }

        // removing all conflicting transactions
        for (Transaction transaction in conflictingTransactions) {
          await blockchain!.mempool.removeTransaction(transaction);
        }
      }
    }
  } catch (e) {
    print(e.toString());
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await serve(handler, ip, port);

  firestore ??= Firestore.initialize("baby-blockchain");

  blockchain ??= await Blockchain.initBlockchain();
}
