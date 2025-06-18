
import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'configuration.dart';








Future<String> encryptMessage(String message, String key) async {
  if (key == "") {
    return message;
  }
  final algorithm = AesGcm.with128bits(nonceLength: CryptographicConfiguration.nonceLength);
  final secretKey = SecretKey(utf8.encode(key));
  final nonce = algorithm.newNonce();

  final SecretBox secretBox = await algorithm.encrypt(
    utf8.encode(message),
    secretKey: secretKey,
    nonce: nonce,
  );
  return utf8.decode(secretBox.cipherText);
}

Future<String> decryptMessage(String message, String key) async {
  if (key == "") {
    return message;
  }
  final algorithm = AesGcm.with128bits(nonceLength: CryptographicConfiguration.nonceLength);
  final secretKey = SecretKey(utf8.encode(key));

  final SecretBox secretBox = await algorithm.encrypt(
    utf8.encode(message),
    secretKey: secretKey,
  );
  return utf8.decode(secretBox.cipherText);
}