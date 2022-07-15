import 'dart:async';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'blockchain/block.dart';
import 'blockchain/blockchain.dart';
import 'blockchain/transaction.dart';

// Configure routes.
final _router = Router();
//..post('/transaction', _postTransactionHandler);

// Future<Response> _postTransactionHandler(Request request) async {
//   try {
//     if (request.method == "POST") {
//       Transaction tranaction =
//           Transaction.fromJSON(jsonDecode(await request.readAsString()));

//       transaction.printTransaction();

//       // Firestore.instance.collection("blockHistory").add({"oh wow": 21});
//       return Response.ok('Accepted');
//     } else {
//       return Response.notFound("${request.method} method is not supported");
//     }
//   } catch (e) {
//     return Response.badRequest(body: e.toString());
//   }
// }

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  Firestore.initialize("baby-blockchain");
  print('Firebase initialized');

  blockchain = await Blockchain.initBlockchain();
  print("Blockchain initialized, ready to run");

  _periodicallyCheckMempool(periodMinutes: 5);
}

void _periodicallyCheckMempool({int periodMinutes = 10}) {
  Timer.periodic(Duration(minutes: periodMinutes), (timer) async {
    while (true) {
      Set<Transaction> pendingTransactions =
          await blockchain!.mempool.getMempool();
      if (pendingTransactions.isEmpty) return;

      Block newBlock = await Block.createBlock(pendingTransactions);

      Map<int, dynamic>? error = await blockchain!.validateBlock(newBlock);

      // the block is valid
      if (error == null) {
        // removing block transactions from mempool
        for (Transaction transaction in pendingTransactions) {
          await blockchain!.mempool.removeTransaction(transaction);
        }

        print("block was successfully validated");
        return;
      }

      // some database sync issue. should be fixed on next run automatically
      if (error.containsKey(1)) {
        print("prevHash != ID of the last block");
      }

      // some invalid transaction
      if (error.containsKey(2) || error.containsKey(3)) {
        Transaction invalidTransaction = error.values.first;
        print("invalid transaction: ${invalidTransaction.toString()}");

        // removing it
        await blockchain!.mempool.removeTransaction(invalidTransaction);
      }

      // conflicting transactions with some robot
      if (error.containsKey(4)) {
        String robotID = error.values.first;
        print("conflicting transactions with robot: ID = $robotID");

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
  });
}
