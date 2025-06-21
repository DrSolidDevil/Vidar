import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'configuration.dart';
import 'settings.dart';

/// If key is blank then it returns the message argument
/// Will output with an encryption prefix (i.e. a string prefix that signals that this is an encrypted message)
Future<String> encryptMessage(String message, String key) async {
  if (key == "") {
    print("No key");
    if (Settings.allowUnencryptedMessages) {
      return message;
    } else {
      return "${MiscellaneousConfiguration.errorPrefix}NO_KEY";
    }
  }

  try {
    final algorithm = AesGcm.with256bits(
      nonceLength: CryptographicConfiguration.nonceLength,
    );

    final List<int> hashedKey = (await Sha256().hash(utf8.encode(key))).bytes;
    final SecretKey secretKey = SecretKey(hashedKey);
    final List<int> nonce = algorithm.newNonce();

    final SecretBox secretBox = await algorithm.encrypt(
      utf8.encode(message),
      secretKey: secretKey,
      nonce: nonce,
    );

    final List<int> fullEncrypted = [
      ...nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];

    return CryptographicConfiguration.encryptionPrefix + base64.encode(fullEncrypted);
  } catch (error, stackTrace) {
    print("Encryption Failed: $error");
    print("Stacktrace:\n$stackTrace");
    return "ENCRYPTION_FAILED";
  }
}

/// If key is blank or encryption prefix is missing then it returns the message argument
/// If decryption fails then it returns "DECRYPTION_FAILED"
Future<String> decryptMessage(String message, String key) async {
  if (key == "") {
    print("No key");
    return message;
  }
  if (!message.startsWith(CryptographicConfiguration.encryptionPrefix)) {
    print("No encryption prefix");
    return message;
  }

  try {
    message = message.replaceFirst(
      CryptographicConfiguration.encryptionPrefix,
      "",
    );

    final algorithm = AesGcm.with256bits(
      nonceLength: CryptographicConfiguration.nonceLength,
    );

    final List<int> hashedKey = (await Sha256().hash(utf8.encode(key))).bytes;
    final SecretKey secretKey = SecretKey(hashedKey);
    final List<int> encryptedBytes = base64.decode(message);

    final nonce = encryptedBytes.sublist(
      0, 
      CryptographicConfiguration.nonceLength,
    );
    final cipherText = encryptedBytes.sublist(
      CryptographicConfiguration.nonceLength,
      encryptedBytes.length - CryptographicConfiguration.macLength,
    );
    final mac = encryptedBytes.sublist(
      encryptedBytes.length - CryptographicConfiguration.macLength
    );

    final SecretBox secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(mac));
    final List<int> decryptedBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
    final String decryptedMessage = utf8.decode(decryptedBytes);
    return decryptedMessage;
  } catch (error, stackTrace) {
    print("Decryption Failed: $error");
    print("Stacktrace:\n$stackTrace");
    return "${MiscellaneousConfiguration.errorPrefix}DECRYPTION_FAILED";
  }
}