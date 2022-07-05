import 'dart:typed_data';

import 'package:baby_blockchain/domain_layer/account.dart';

/// [VerificationalToken] is sent each time the application connects to the robot.
/// Technically, [VerificationalToken] is a result of signing given `robotID` with
/// the private key of given account. Since robot "knows" its ID and accountID of
/// its owner (hence public key as well), it already "knows" the message (`robotID`),
/// which was signed, and public key of the signer (given account).
/// It is enough to verify the corresponding signature <=> determine, if the one,
/// who sent the token knows the private key of the account, which is the owner of the robot.
class VerificationalToken {
  /// Signs the given `robotID` with the given [Account].
  static Uint8List generate(Account account, String robotID) {
    Uint8List signature = account.signData(robotID);
    return signature;
  }
}
