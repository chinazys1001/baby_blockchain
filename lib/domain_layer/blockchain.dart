import 'package:baby_blockchain/data_layer/block_history.dart';
import 'package:baby_blockchain/data_layer/mempool.dart';
import 'package:baby_blockchain/data_layer/robot_database.dart';
import 'package:baby_blockchain/data_layer/tx_database.dart';
import 'package:baby_blockchain/domain_layer/block.dart';
import 'package:baby_blockchain/domain_layer/hash.dart';
import 'package:baby_blockchain/domain_layer/operation.dart';
import 'package:flutter/foundation.dart';
import 'package:baby_blockchain/domain_layer/transaction.dart';

/// Global instance of [Blockchain] class, which is used to interact with the blockhain resources.
Blockchain blockchain = Blockchain(
  robotDatabase: RobotDatabase(),
  blockHistory: BlockHistory(),
  txDatabase: TXDatabase(),
  mempool: Mempool(),
);

/// Custom implementation of [Blockchain] class. Usage description can be found in README.
class Blockchain {
  Blockchain({
    required this.robotDatabase,
    required this.blockHistory,
    required this.txDatabase,
    required this.mempool,
  });

  /// Technically, `robotDatabase` is a HashMap (key -> accountID,
  /// value -> list of robots, owned by the corresponding account, and `nonce` of the account).
  /// [RobotDatabase] class was additionally created in order
  /// to simplify the interaction with the server-side resources.
  final RobotDatabase robotDatabase;

  /// Technically, `blockHistory` is a list of all the transactions ever created.
  /// [BlockHistory] class was additionally created in order
  /// to simplify the interaction with the server-side resources.
  final BlockHistory blockHistory;

  /// Technically, `txDatabase` is a list of all the transactions ever created.
  /// [TXDatabase] class was additionally created in order
  /// to simplify the interaction with the server-side resources.
  final TXDatabase txDatabase;

  /// Technically, `mempool` is a set of all pending transactions.
  /// [TXDatabase] class was additionally created in order
  /// to simplify the interaction with the server-side resources.
  final Mempool mempool;

  /// Initializing blockchain: both `robotDatabase` and `txDatabase` are empty.
  /// `blockHistory` contains the generated genesis block.
  /// Genesis block has an undefined `prevHash` and an empty `setOfTransactions`.
  static Future<Blockchain> initBlockchain() async {
    // initializing blank databases
    RobotDatabase robotDatabase = RobotDatabase();
    BlockHistory blockHistory = BlockHistory();
    TXDatabase txDatabase = TXDatabase();
    Mempool mempool = Mempool();

    // adding genesis block to the blockHistory
    Set<Transaction> setOfTransactions = {}; // empty
    int height = 0;
    String blockID = Hash.toSHA256(height.toString() +
        setOfTransactions.toString()); // other fields are empty
    Block genesisBlock = Block(
      blockID: blockID,
      prevHash: "", // undefined
      setOfTransactions: setOfTransactions,
      height: height,
    );
    await blockHistory.addBlock(genesisBlock);

    return Blockchain(
      robotDatabase: robotDatabase,
      blockHistory: blockHistory,
      txDatabase: txDatabase,
      mempool: mempool,
    );
  }

  /// Block validation:
  /// 1. Checking if the `prevHash` of the given block is equal to the ID of the last block in `blockHistory`.
  /// 2. Checking if all the transactions of the given block are absent in `txDatabase`.
  /// 3. Checking if there are no transaction conflicts.
  /// 4. Verifying operations of each transaction using [Operation.verifyOperaton].
  /// If all validation steps complete normally, the block gets added to `blockHistory`,
  /// its transactions are executed and added to `txDataabase` and null is returned.
  /// If any step fails error is returned. Error is a pair<step_number, error_description>.
  Future<Map<int, dynamic>?> validateBlock(Block block) async {
    // step 1. comparing block.prevHash with ID of the top block in blockHistory
    // if they are not equal, return error
    Block topBlock = await blockHistory.getTopBlock();
    if (topBlock.blockID != block.prevHash) {
      return {0: topBlock.blockID};
    }

    // step 2. checking for each transaction if it is absent in txDatabase
    // if at least one transaction is present in txDatabase, return error
    for (Transaction transaction in block.setOfTransactions) {
      bool transactionAlreadyExists =
          await txDatabase.transactionExists(transaction);
      if (transactionAlreadyExists) {
        return {2: transaction};
      }
    }

    // step 3. verifying each operation using [Operation.verifyOperation] method
    for (Transaction transaction in block.setOfTransactions) {
      bool operationIsValid =
          await Operation.verifyOperation(transaction.operation);
      if (!operationIsValid) {
        // return error
        return {3: transaction};
      }
    }

    // step 4. going through all transactions and checking if there are attempts
    // to transfer the same robot from one account to at least 2 other accounts.
    // to clarify, here is an example of such a conflict:
    // say account A owns robot R (if it actually does - we've verified in the 3-rd step).
    // let's assume there is a transaction T1 which "sends" Robot R from
    // account A to some account B. this transaction seems to be OK.
    // the issue comes in when there is an attempt to create some other
    // transaction T2, which also "transmits" robot R from account A to any other account.
    // if there is no some other transaction T3, which "returns" robot R to account A,
    // we`ve run into a problem - transaction T2 tries to "send" robot R from account A,
    // although account A actually does not own the robot (as a result of transaction T1).
    // if smth similar occurs, FALSE is returned

    // emulating the changes the transactions of block.setOfTransactions result in
    // key is account ID, value is Map with boolean keys
    // (true stands for the "received" robots, false - "spent" ones)
    // and corresponding values (list of robotIDs, which were "received" / "spent" by the account)
    Map<String, Map<bool, Map<String, int>>> trState = {};

    // completing trState
    for (Transaction transaction in block.setOfTransactions) {
      String senderID = transaction.operation.senderID;
      String receiverID = transaction.operation.receiverID;
      String robotID = transaction.operation.robotID;

      // on first occurance of account with ID = senderID
      if (trState[senderID] == null) {
        trState[senderID] = {
          true: {},
          false: {},
        };
      }
      // on first occurance in sender's "sent" map
      if (trState[senderID]![false]![robotID] == null) {
        trState[senderID]![false]![robotID] = 0;
      }
      // incrementing counter
      trState[senderID]![false]![robotID] =
          (trState[senderID]![false]![robotID]! + 1);

      // on first occurance of account with ID = receiverID
      if (trState[receiverID] == null) {
        trState[receiverID] = {
          true: {},
          false: {},
        };
      }
      // on first occurance in receiver's "received" map
      if (trState[receiverID]![true]![robotID] == null) {
        trState[receiverID]![true]![robotID] = 0;
      }
      // incrementing counter
      trState[receiverID]![true]![robotID] =
          (trState[receiverID]![true]![robotID]! + 1);
    }

    // checking if the difference between number of occurances in "sent" map
    // and number of occurances in "received" map is equal to -1, 0 or 1 for
    // each robot of each account. for example, if account A sent a robot R to
    // account B, then there is a single R.robotID value in "sent" list and zero
    // occurances in "received" map, the difference is equal to 1. from the point
    // of view of account B everything is contrariwise => the difference = -1.
    // then, if account B sends robot R back to the account A, both "received"
    // and "sent" maps of both accounts have a single occurance of R.robotID =>
    // the difference is equal to 0. all these scenarioshave no conflicts.
    // now, let's assume that robot R was sent from account A to some account C.
    // currently, everuthing's OK. but if then account A will try to send the same
    // robot R to some other account D, we've run into a conflict, as
    // the number of occurances in "received" map is still equal to 1, while
    // the "sent" map has 3 of them => the difference = 2 => the conflict was
    // spotted => return FALSE
    for (Map<bool, Map<String, int>> account in trState.values) {
      // key -> ID of the received robot. value -> number of times it was received
      // by the account across all transactions of the block
      Map<String, int> receivedRobotsMap = account[true]!;

      // key -> ID of the sent robot. value -> number of times it was sent
      // by the account across all transactions of the block
      Map<String, int> sentRobotsMap = account[false]!;

      // collecting all robotIDs from "received" and "sent" map
      Set<String> allRobotIDsOfTransaction = Set<String>.from(
        List.from(receivedRobotsMap.keys) + List.from(sentRobotsMap.keys),
      );

      for (String robotID in allRobotIDsOfTransaction) {
        int receivedCounter = 0, sentCounter = 0;
        if (receivedRobotsMap[robotID] != null) {
          receivedCounter = receivedRobotsMap[robotID]!;
        }
        if (sentRobotsMap[robotID] != null) {
          sentCounter = sentRobotsMap[robotID]!;
        }
        int difference = sentCounter - receivedCounter;
        if (difference.abs() > 1) {
          return {4: robotID};
        }
      }
    }

    // all steps were completed normally => block is valid
    // => adding it to blockHistory and executing its transactions
    await blockHistory.addBlock(block);
    for (Transaction transaction in block.setOfTransactions) {
      Transaction.executeVerifiedTransaction(transaction);
    }

    return null;
  }

  /// Printing robotDatabase
  Future<void> showRobotDatabase() async {
    if (kDebugMode) {
      print(await robotDatabase.robotDatabaseToString());
    }
  }

  /// Testing-only
  Future<void> printBlockchain() async {
    if (kDebugMode) {
      print("-----------------------Blockchain-----------------------");
      print("robotDatabase: ${await robotDatabase.robotDatabaseToString()}");
      print("blockHistory: ${await blockHistory.blockHistoryToString()}");
      print("txDatabase: ${await txDatabase.txDatabaseToString()}");
      print("mempool: ${await mempool.mempoolToString()}");
      print("--------------------------------------------------------");
    }
  }

  Future<String> blockchainToString() async {
    Map<String, dynamic> mapBlockchain = {
      "robotDatabase": await robotDatabase.robotDatabaseToString(),
      "blockHistory": await blockHistory.blockHistoryToString(),
      "txDatabase": await txDatabase.txDatabaseToString(),
      "mempool": await mempool.mempoolToString(),
    };
    return mapBlockchain.toString();
  }
}
