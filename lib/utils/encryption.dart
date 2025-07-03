import "dart:convert";

import "package:cryptography/cryptography.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/settings.dart";

const String _ENCRYPTION_FAILED = "${MiscellaneousConfiguration.errorPrefix}ENCRYPTION_FAILED";
const String _DECRYPTION_FAILED = "${MiscellaneousConfiguration.errorPrefix}DECRYPTION_FAILED";
const String _NO_KEY = "${MiscellaneousConfiguration.errorPrefix}NO_KEY";

/// If key is blank then it returns the message argument
/// Will output with an encryption prefix (i.e. a string prefix that signals that this is an encrypted message)
Future<String> encryptMessage(final String message, final String key) async {
  if (key == "") {
    if (Settings.keepLogs) {
      CommonObject.logger!.info("No key for encryption");
    }
    if (Settings.allowUnencryptedMessages) {
      return message;
    } else {
      return _NO_KEY;
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
  } on Exception catch (error, stackTrace) {
    if (Settings.keepLogs) {
      CommonObject.logger!.warning(
        "Failed to encrypt message",
        error,
        stackTrace,
      );
    }
    return _ENCRYPTION_FAILED;
  }
}

/// If key is blank or encryption prefix is missing then it returns the message argument
/// If decryption fails then it returns "DECRYPTION_FAILED"
Future<String> decryptMessage(final String message, final String key, {AesGcm? algorithm}) async {
  if (key == "") {
    if (Settings.keepLogs) {
      CommonObject.logger!.info("No key for decryption");
    }
    return message;
  }
  if (!message.startsWith(CryptographicConfiguration.encryptionPrefix)) {
    if (Settings.keepLogs) {
      CommonObject.logger!.info("No encryption prefix");
    }
    return message;
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
    return decryptedMessage;
  } on Exception catch (error, stackTrace) {
    if (Settings.keepLogs) {
      CommonObject.logger!.warning(
        "Failed to decrypt message",
        error,
        stackTrace,
      );
    }
    return _DECRYPTION_FAILED;
  }
}
