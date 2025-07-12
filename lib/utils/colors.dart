import "package:flutter/material.dart";

class ColorSet {
  late final String colorSetName;
  late final Color primary;
  late final Color secondary;
  late final Color tertiary;
  late final Color wipeKeyButton;
  late final Color text;
  late final Color inactiveTrack;
  late final Color? dropdownFocus;
  late final Color? sendButton;
  late final Color? shareQrButton;
  late final Color? qrCode;
}

const List<String> availableColorSets = <String>[
  "Default",
  "Playa",
  "Monochrome",
  "Bubbly",
];

class VidarColorSet extends ColorSet {
  VidarColorSet() {
    colorSetName = "Default";

    /// #1a1c28
    primary = const Color.fromARGB(255, 26, 28, 40);

    /// #64007b
    secondary = const Color.fromARGB(255, 53, 22, 100);

    /// #b18c19
    tertiary = const Color.fromARGB(255, 177, 140, 25);

    /// #140627
    inactiveTrack = const Color.fromARGB(255, 20, 6, 39);

    /// #b22222
    wipeKeyButton = const Color.fromARGB(255, 178, 34, 34);

    text = Colors.white;

    dropdownFocus = null;
    sendButton = null;
    shareQrButton = null;
    qrCode = tertiary;
  }
}

class PlayaColorSet extends ColorSet {
  PlayaColorSet() {
    colorSetName = "Playa";

    /// #FFFA8D
    primary = const Color.fromARGB(255, 255, 250, 141);

    /// #A8F1FF
    secondary = const Color.fromARGB(255, 168, 241, 255);

    /// 4ED7F1
    tertiary = const Color.fromARGB(255, 78, 215, 241);

    /// #FADA7A
    inactiveTrack = const Color.fromARGB(255, 250, 218, 122);

    /// #FF7D29
    wipeKeyButton = const Color.fromARGB(255, 255, 125, 41);

    /// #F2F6D0
    text = const Color.fromARGB(255, 28, 60, 103);

    dropdownFocus = null;
    sendButton = null;
    shareQrButton = null;
    qrCode = null;
  }
}

class MonochromeColorSet extends ColorSet {
  MonochromeColorSet() {
    colorSetName = "Monochrome";
    primary = const Color.fromARGB(255, 30, 30, 30);
    secondary = Colors.black;
    tertiary = const Color.fromARGB(255, 83, 83, 83);
    inactiveTrack = const Color.fromARGB(255, 111, 111, 111);
    wipeKeyButton = const Color.fromARGB(255, 200, 200, 200);
    text = Colors.white;
    dropdownFocus = null;
    sendButton = null;
    shareQrButton = null;
    qrCode = null;
  }
}

class BubblyColorSet extends ColorSet {
  BubblyColorSet() {
    colorSetName = "Bubbly";

    /// #084b83
    primary = const Color.fromARGB(255, 8, 75, 131);

    /// #ff66b3
    secondary = const Color.fromARGB(255, 255, 102, 179);

    /// #022d40
    tertiary = const Color.fromARGB(255, 2, 45, 64);

    /// #42bfdd
    inactiveTrack = const Color.fromARGB(255, 66, 191, 221);

    /// #a528ff
    wipeKeyButton = const Color.fromARGB(255, 165, 40, 255);

    /// #f0f6f6
    text = const Color.fromARGB(255, 240, 246, 246);

    dropdownFocus = wipeKeyButton;
    sendButton = primary;
    shareQrButton = wipeKeyButton;
    qrCode = secondary;
  }
}

/// If color set is not found then it returns default
ColorSet getColorSetFromName(final String colorSetName) {
  switch (colorSetName.toLowerCase()) {
    case "playa":
      return PlayaColorSet();
    case "monochrome":
      return MonochromeColorSet();
    case "bubbly":
      return BubblyColorSet();
    default:
      return VidarColorSet();
  }
}
