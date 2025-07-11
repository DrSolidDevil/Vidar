import "package:logging/logging.dart";

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
  static const int messageWidgetErrorDisplayTime = 15;
  static const int smsUpdateDelay = 1;
  // Milliseconds
  static const int decryptingLoadingText = 200;
  // Seconds to delay before going to next "decryption" with DecryptingText loader
  static const int delayOnCompletedDecryptedLoading = 2;
}

class MiscellaneousConfiguration {
  static const String errorPrefix = "⚠";
  static const List<String> messageHints = <String>[
    "Write them a message!",
    "Show them some love ❤️",
    "Tell them your secrets 👀",
    "Start gossiping...",
    "Talk to them, they miss you.",
  ];
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
