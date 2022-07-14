import 'blockchain.dart';
import 'hash.dart';
import 'transaction.dart';

/// Custom implementation of [Block] class. Usage description can be found in README.
class Block {
  Block({
    required this.blockID,
    required this.prevHash,
    required this.setOfTransactions,
    required this.height,
  });

  /// Unique Id of a [Block] is equal to the hash value of `prevHash` and `setOfTransactions`.
  final String blockID;

  /// `blockID` of the previous block.
  final String prevHash;

  /// Set of [Transaction]s to be included in the [Block].
  final Set<Transaction> setOfTransactions;

  /// Height of the block.
  final int height;

  /// Creating block, which contains the given `setOfTransactions`.
  /// Block `prevHash` is the ID of the last block in `blockHistory`.
  /// Block `height` is the height of the last block in `blockHistory` + 1.
  /// Block `blockID` is hash value of these values.
  static Future<Block> createBlock(Set<Transaction> setOfTransactions) async {
    Block topBlock = await blockchain!.blockHistory.getTopBlock();
    String blockID = Hash.toSHA256(topBlock.blockID +
        setOfTransactions.toString() +
        {topBlock.height + 1}.toString());

    return Block(
      blockID: blockID,
      prevHash: topBlock.blockID,
      setOfTransactions: setOfTransactions,
      height: topBlock.height + 1,
    );
  }

  /// Testing-only
  void printBlock() {
    print("-------------------------Block-------------------------");
    print("Block ID: $blockID");
    print("Previous Hash: $prevHash");
    print("Nonce: ${setOfTransactions.toString()}");
    print("Height: ${height.toString()}");
    print("-------------------------------------------------------");
  }

  @override
  String toString() {
    Map<String, dynamic> mapTransaction = {
      "blockID": blockID,
      "prevHash": prevHash,
      "setOfTransactions": setOfTransactions.toString(),
      "height": height.toString(),
    };
    return mapTransaction.toString();
  }
}
