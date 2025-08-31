import "dart:convert";

import "package:cryptography/cryptography.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/encryption_exceptions.dart";
import "package:vidar/utils/settings.dart";

/// If key is blank then it returns the message argument as is
/// Will output with an encryption prefix (i.e. a string prefix that signals that this is an encrypted message)
Future<String> encryptMessage(final String message, final String key) async {
  if (key == "") {
    if (Settings.keepLogs) {
      CommonObject.logger!.info(
        "No key for encryption (${Settings.allowUnencryptedMessages ? "allowed" : "not allowed"})",
      );
    }
    if (Settings.allowUnencryptedMessages) {
      return message;
    } else {
      throw NoKeyException();
    }
  }

  try {
    final AesGcm algorithm = AesGcm.with256bits(
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

    final List<int> fullEncrypted = <int>[
      ...nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];

    return CryptographicConfiguration.encryptionPrefix +
        base64.encode(fullEncrypted);
  } catch (error, stackTrace) {
    if (Settings.keepLogs) {
      CommonObject.logger!.finest(
        "Failed to encrypt message",
        error,
        stackTrace,
      );
    }
    throw EncryptionException(error.toString());
  }
}

/// If key is blank or encryption prefix is missing then it returns the message argument as is
Future<(String, Exception?)> decryptMessage(
  final String message,
  final String key, {
  AesGcm? algorithm,
}) async {
  if (key == "") {
    if (Settings.keepLogs && !CryptographicConfiguration.allowNoKey) {
      CommonObject.logger!.info("No key for decryption");
    }
    return (message, NoKeyException());
  }
  if (!message.startsWith(CryptographicConfiguration.encryptionPrefix)) {
    if (Settings.keepLogs && LoggingConfiguration.extraVerboseLogs) {
      CommonObject.logger!.info("No encryption prefix");
    }
    return (message, NoEncryptionPrefixException());
  }

  try {
    final String trimmedMessage = message.replaceFirst(
      CryptographicConfiguration.encryptionPrefix,
      "",
    );

    algorithm ??= AesGcm.with256bits(
      nonceLength: CryptographicConfiguration.nonceLength,
    );

    final List<int> hashedKey = (await Sha256().hash(utf8.encode(key))).bytes;
    final SecretKey secretKey = SecretKey(hashedKey);
    final List<int> encryptedBytes = base64.decode(trimmedMessage);

    final List<int> nonce = encryptedBytes.sublist(
      0,
      CryptographicConfiguration.nonceLength,
    );
    final List<int> cipherText = encryptedBytes.sublist(
      CryptographicConfiguration.nonceLength,
      encryptedBytes.length - CryptographicConfiguration.macLength,
    );
    final List<int> mac = encryptedBytes.sublist(
      encryptedBytes.length - CryptographicConfiguration.macLength,
    );

    final SecretBox secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(mac),
    );
    final List<int> decryptedBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
    final String decryptedMessage = utf8.decode(decryptedBytes);
    return (decryptedMessage, null);
  } on SecretBoxAuthenticationError catch (error) {
    if (Settings.keepLogs) {
      CommonObject.logger!.warning("Failed to decrypt message", error);
    }
    return ("", DecryptionException(error.toString()));
  } catch (error, stackTrace) {
    if (Settings.keepLogs) {
      CommonObject.logger!.finer(
        "Failed to decrypt message",
        error,
        stackTrace,
      );
    }
    return ("", DecryptionException(error.toString()));
  }
}
