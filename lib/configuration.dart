import "package:flutter/material.dart";
import "package:logging/logging.dart";

class VidarColors {
  /// #1a1c28
  static const Color primaryDarkSpaceCadet = Color.fromARGB(255, 26, 28, 40);

  /// #64007b
  static const Color secondaryMetallicViolet = Color.fromARGB(255, 53, 22, 100);

  /// #b18c19
  static const Color tertiaryGold = Color.fromARGB(255, 177, 140, 25);

  /// #140627
  static const Color extraMidnightPurple = Color.fromARGB(255, 20, 6, 39);

  /// #b22222
  static const Color extraFireBrick = Color.fromARGB(255, 178, 34, 34);
}

class CryptographicConfiguration {
  // Length in bytes
  static const int keyGenerationHashLength = 15;
  static const int nonceLength = 32;
  static const String encryptionPrefix = "☍";
  // Standard is 16 bytes for the cryptography library
  static const int macLength = 16;
  static const bool allowNoKey = true;
}

class SizeConfiguration {
  static const double sendMessageIconSize = 30;
  static const double messageIndent = 10;
  static const double messageVerticalSeperation = 5;
  static const double settingInfoText = 12;
  static const double loadingFontSize = 32;
}

class TimeConfiguration {
  // Seconds
  static const int messageWidgetErrorDisplayTime = 5;
  static const int smsUpdateDelay = 1;
  // Milliseconds
  static const int decryptingLoadingText = 200;
  // Seconds to delay before going to next "decryption" with DecryptingText loader
  static const int delayOnCompletedDecryptedLoading = 2;
}

class MiscellaneousConfiguration {
  static const String errorPrefix = "⚠";
}

class LoggingConfiguration {
  /// If encryption errors should be logged/printed
  static const bool verboseEncryptionError = false;

  static const String loggerName = "VidarLogger";

  static const bool extraVerboseLogs = true;

  static const String logFileSaveLocation = "/storage/emulated/0/Download";

  static String logFileName() {
    return "vidarlogs_${DateTime.now().millisecondsSinceEpoch}.txt";
  }

  static String verboseLogMessage(final LogRecord log) {
    return "\n${log.sequenceNumber}: ${log.time.toIso8601String()}\nLevel: ${log.level.name}\nError: ${log.error}\nMessage: ${log.message}\nStack Trace: ${log.stackTrace}";
  }

  static String conciseLogMessage(final LogRecord log) {
    return "\n${log.sequenceNumber}: ${log.time.toIso8601String()}\nLevel: ${log.level.name}\nMessage: ${log.message}";
  }
}
