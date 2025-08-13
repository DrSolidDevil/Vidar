import "package:device_info_plus/device_info_plus.dart" show AndroidDeviceInfo;
import "package:logging/logging.dart";
import "package:package_info_plus/package_info_plus.dart" show PackageInfo;

void externalConfiguration() {
  // Required to be true if you want to change log level of loggers (e.g. allow config messages).
  hierarchicalLoggingEnabled = true;
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
  static const double feedbackFormFontSize = 12;
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
  // Probability of the user seeing a dialog prompting them to give feedback 0-1, 
  // where 1 means showing it always.
  static const double userFeedbackDialogProbability = 1; 
  static const Duration userFeedbackDialogPopupWait = const Duration(seconds: 1); 
  static const String userFeedbackEmailAddress = "drsoliddevil+vidarfeedback@gmail.com";
}

class LoggingConfiguration {
  static const String loggerName = "VidarLogger";

  static const bool extraVerboseLogs = true;

  static const String logFileSaveLocation = "/storage/emulated/0/Download";

  static String logFileName() {
    return "vidarlogs_${DateTime.now().millisecondsSinceEpoch}.txt";
  }

  static String verboseLogMessage(final LogRecord log) {
    return """
[${log.sequenceNumber}] ${log.time.toIso8601String()}
\tLevel: ${log.level.name}
\tError: ${log.error}
\tMessage: ${log.message.replaceAll("\n", "\n\t")}
\tStack Trace: ${log.stackTrace}
    """;
  }

  static String normalLogMessage(final LogRecord log) {
    return """
[${log.sequenceNumber}] ${log.time.toIso8601String()}
\tLevel: ${log.level.name}
\tError: ${log.error}
\tMessage: ${log.message.replaceAll("\n", "\n\t")}
    """;
  }

  static String conciseLogMessage(final LogRecord log) {
    return """
[${log.sequenceNumber}] ${log.time.toIso8601String()}
\tLevel: ${log.level.name}
\tMessage: ${log.message.replaceAll("\n", "\n\t")}
    """;
  }

  static String minimalLogMessage(final LogRecord log) {
    return """
[${log.sequenceNumber}] ${log.time.toIso8601String()}
\t${log.message.replaceAll("\n", "\n\t")}
    """;
  }

  static String initLog({
    required final PackageInfo packageInfo,
    required final AndroidDeviceInfo deviceInfo,
  }) {
    return """
========== APP INFO ==========
App Name: ${packageInfo.appName}
Version: ${packageInfo.version}
Build Number: ${packageInfo.buildNumber}
======== DEVICE INFO =========
Base OS: ${deviceInfo.version.baseOS == "" ? "unknown" : deviceInfo.version.baseOS}
Bootloader: ${deviceInfo.bootloader}
Total RAM: ${deviceInfo.physicalRamSize} MB
Release ${deviceInfo.version.release}
SDK: ${deviceInfo.version.sdkInt}
Security Patch: ${deviceInfo.version.securityPatch}
Manufacturer: ${deviceInfo.manufacturer}
Brand: ${deviceInfo.brand}
Model: ${deviceInfo.model}
Emulator: ${!deviceInfo.isPhysicalDevice}
Hardware Keystore: ${deviceInfo.systemFeatures.contains("android.hardware.hardware_keystore")}
Telephony: ${deviceInfo.systemFeatures.contains("android.hardware.telephony")}
Telephony Messaging: ${deviceInfo.systemFeatures.contains("android.hardware.telephony.messaging")}
Telephony Subscription: ${deviceInfo.systemFeatures.contains("android.hardware.telephony.subscription")}
Any Camera: ${deviceInfo.systemFeatures.contains("android.hardware.camera.any")}
==============================
    """;
  }
}
