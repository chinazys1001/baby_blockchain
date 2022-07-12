import 'dart:convert';

import 'package:crypto/crypto.dart';

// for SHA-256 implementation, see https://pub.dev/packages/crypto
// the implementation is standart, similar to the one I provided in Task #3
// see https://github.com/chinazys1001/distributed_lab_workshop/blob/main/Task%203/sha256.py for complete Python code
/// Custom implementation [Hash] class. Usage description can be found in README.
class Hash {
  /// Returns hash value of given string
  static String toSHA256(String input) {
    List<int> inputBytes = utf8.encode(input);
    String output = sha256.convert(inputBytes).toString();
    return output;
  }

  /// Verify if the hash of the given string matches the given hash
  static bool matches(String value, String hash) {
    return Hash.toSHA256(value) == hash;
  }
}
