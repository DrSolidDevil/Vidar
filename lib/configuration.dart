import 'package:flutter/material.dart';

class VidarColors {
  /// #1a1c28
  static const primaryDarkSpaceCadet = Color.fromARGB(255, 26, 28, 40);

  /// #64007b
  static const secondaryMetallicViolet = Color.fromARGB(255, 53, 22, 100);

  /// #b18c19
  static const tertiaryGold = Color.fromARGB(255, 177, 140, 25);

  /// #140627
  static const extraMidnightPurple = Color.fromARGB(255, 20, 6, 39);
}

class CryptographicConfiguration {
  // Length in bytes (18 bytes = 144 bits)
  static const int keyGenerationHashLength = 15;
  static const int nonceLength = 32;
  static const String encryptionPrefix = "☍";
  // Standard is 16 bytes for the cryptography library
  static const int macLength = 16;
  static const bool allowNoKey = true;
}

class ErrorHandlingConfiguration {
  static const bool reportErrorOnFailedLoad = true;
  static const bool reportErrorOnFailedSave = true;
}

class SizeConfiguration {
  static const double sendMessageIconSize = 30.0;
  static const double messageIndent = 10.0;
  static const double messageVerticalSeperation = 5.0;
  static const double settingInfoText = 12.0;
}

class TimeConfiguration {
  // Seconds
  static const int messageWidgetErrorDisplayTime = 5;
}

class MiscellaneousConfiguration {
  static const String errorPrefix = "⚠";
}

class LoggingConfiguration {
  /// If encryption errors should be logged/printed
  static const bool verboseEncryptionError = false;
}
