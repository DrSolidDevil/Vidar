import "dart:convert";
import "dart:math";

import "package:cryptography/cryptography.dart";
import "package:vidar/configuration.dart";

Future<String> generateRandomKey() async {
  //  The default implementation of nextInt supports max values between 1 and (1<<32) inclusive.
  final int randomNumber = Random.secure().nextInt(4294967296);
  final Hash hash = await Blake2b(
    hashLengthInBytes: CryptographicConfiguration.keyGenerationHashLength,
  ).hash(<int>[randomNumber]);
  final String key = base64Encode(hash.bytes);
  return key;
}
