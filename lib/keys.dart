import 'dart:convert';

import 'configuration.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:math';

Future<String> generateRandomKey() async {
  
  final int randomNumber = Random.secure().nextInt(4294967296);
  final Hash hash = await Blake2b(
    hashLengthInBytes: CryptographicConfiguration.keyGenerationHashLength,
  ).hash([randomNumber]);
  final String key = base64Encode(hash.bytes);
  return key;
}
