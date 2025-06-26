import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:vidar/configuration.dart';

Future<String> generateRandomKey() async {
  final randomNumber = Random.secure().nextInt(4294967296);
  final hash = await Blake2b(
    hashLengthInBytes: CryptographicConfiguration.keyGenerationHashLength,
  ).hash([randomNumber]);
  final key = base64Encode(hash.bytes);
  return key;
}
