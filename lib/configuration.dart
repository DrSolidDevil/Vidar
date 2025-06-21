import 'package:flutter/material.dart';

class VidarColors {
  /// #64007B
  static const secondaryMetallicViolet = Color.fromARGB(255, 53, 22, 100);
  /// #1a1c28
  static const primaryDarkSpaceCadet = Color.fromARGB(255, 26, 28, 40);
  /// #b18c19
  static const tertiaryGold = Color.fromARGB(255, 	177, 140, 25);
  /*static const primary2 = Color.fromARGB(255, );
  static const primary2 = Color.fromARGB(255, );
  static const primary2 = Color.fromARGB(255, );
  
  
  
  
  
  
  */
}

class CryptographicConfiguration {
  // Length in bytes (18 bytes = 144 bits)
  static const int keyGenerationHashLength = 18; 
  static const int nonceLength = 32;
  static const String encryptionPrefix = "☍";
  // Standard is 16 bytes for the cryptography library
  static const int macLength = 16; 
}



class SizeConfiguration {
  static const double sendMessageIconSize = 30.0;
  static const double messageIndent = 10.0;
  static const double messageVerticalSeperation = 3.0;
}

class TimeConfiguration {
  // Seconds
  static const int messageWidgetErrorDisplayTime = 5;
}

class MiscellaneousConfiguration {
  static const String errorPrefix = "⚠";
}


