import "package:flutter/material.dart";

class ColorSet {
  ColorSet({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.text,
    final Color? pWipeKeyButton,
    final Color? pInactiveTrack,
    final Color? pDropdownFocus,
    final Color? pSendButton,
    final Color? pFloatingActionButton,
    final Color? pWipeKeyButtonText,
    final Color? pMessageBarHintText,
    final Color? pExportLogsButton,
    final Color? pFeedbackHintText,
    final Color? pFeedbackBackground,
    final Color? pDialogButtonText,
    final Color? pDialogText,
    final Color? pDialogBackground,
    final Color? pFeedbackScrollbar,
    final Color? pDialogScrollbar,
    final Color? pMessageBarScrollbar,
  }) {
    wipeKeyButton = pWipeKeyButton ?? secondary;
    inactiveTrack = pInactiveTrack ?? primary;
    dropdownFocus = pDropdownFocus ?? tertiary;
    sendButton = pSendButton ?? primary;
    floatingActionButton = pFloatingActionButton ?? tertiary;
    wipeKeyButtonText = pWipeKeyButtonText ?? text;
    messageBarHintText = pMessageBarHintText ?? text;
    exportLogsButton = pExportLogsButton ?? tertiary;
    feedbackHintText = pFeedbackHintText ?? secondary;
    feedbackBackground = pFeedbackBackground ?? primary;
    dialogButtonText = pDialogButtonText ?? secondary;
    dialogText = pDialogText ?? text;
    dialogBackground = pDialogBackground ?? tertiary;
    feedbackScrollbar = pFeedbackScrollbar ?? tertiary;
    dialogScrollbar = pDialogScrollbar ?? tertiary;
    messageBarScrollbar = pMessageBarScrollbar ?? tertiary;
  }
  final String name;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color text;

  late final Color wipeKeyButton;
  late final Color inactiveTrack;
  late final Color dropdownFocus;
  late final Color sendButton;
  late final Color floatingActionButton;
  late final Color wipeKeyButtonText;
  late final Color messageBarHintText;
  late final Color exportLogsButton;
  late final Color feedbackHintText;
  late final Color feedbackBackground;
  late final Color dialogButtonText;
  late final Color dialogText;
  late final Color dialogBackground;
  late final Color feedbackScrollbar;
  late final Color dialogScrollbar;
  late final Color messageBarScrollbar;
}

final List<String> availableColorSets = <String>[
  vidarColorSet.name,
  playaColorSet.name,
  monochromeColorSet.name,
  bubblyColorSet.name,
];

final ColorSet vidarColorSet = ColorSet(
  name: "Default",
  primary: const Color.fromARGB(255, 26, 28, 40),
  secondary: const Color.fromARGB(255, 53, 22, 100),
  tertiary: const Color.fromARGB(255, 177, 140, 25),
  text: Colors.white,
  pWipeKeyButton: const Color.fromARGB(255, 178, 34, 34),
  pFloatingActionButton: const Color.fromARGB(255, 39, 8, 86),
  pMessageBarHintText: const Color.fromARGB(255, 172, 116, 255),
  pSendButton: const Color.fromARGB(255, 172, 116, 255),
  pFeedbackHintText: const Color.fromARGB(255, 109, 71, 166),
  pFeedbackBackground: const Color.fromARGB(255, 30, 32, 45),
  pDialogBackground: const Color.fromARGB(255, 172, 116, 255),
  pDialogText: const Color.fromARGB(255, 53, 22, 100),
  pDialogButtonText: const Color.fromARGB(255, 26, 28, 40),
  pFeedbackScrollbar: const Color.fromARGB(255, 109, 71, 166),
  pDialogScrollbar: const Color.fromARGB(255, 109, 71, 166),
  pMessageBarScrollbar: const Color.fromARGB(255, 172, 116, 255),
);

final ColorSet playaColorSet = ColorSet(
  name: "Playa",
  primary: const Color.fromARGB(255, 255, 250, 141),
  secondary: const Color.fromARGB(255, 168, 241, 255),
  tertiary: const Color.fromARGB(255, 78, 215, 241),
  text: const Color.fromARGB(255, 28, 60, 103),
  pWipeKeyButton: const Color.fromARGB(255, 255, 125, 41),
  pInactiveTrack: const Color.fromARGB(255, 250, 218, 122),
);

final ColorSet monochromeColorSet = ColorSet(
  name: "Monochrome",
  primary: const Color.fromARGB(255, 30, 30, 30),
  secondary: Colors.black,
  tertiary: const Color.fromARGB(255, 83, 83, 83),
  text: Colors.white,
  pWipeKeyButton: const Color.fromARGB(255, 200, 200, 200),
  pInactiveTrack: const Color.fromARGB(255, 41, 41, 41),
  pSendButton: const Color.fromARGB(255, 200, 200, 200),
  pWipeKeyButtonText: Colors.black,
);

final ColorSet bubblyColorSet = ColorSet(
  name: "Bubbly",
  primary: const Color.fromARGB(255, 8, 75, 131),
  secondary: const Color.fromARGB(255, 255, 102, 179),
  tertiary: const Color.fromARGB(255, 2, 45, 64),
  text: const Color.fromARGB(255, 240, 246, 246),
  pWipeKeyButton: const Color.fromARGB(255, 255, 40, 183),
  pInactiveTrack: const Color.fromARGB(255, 66, 191, 221),
  pSendButton: const Color.fromARGB(255, 8, 75, 131),
  pDropdownFocus: const Color.fromARGB(255, 165, 40, 255),
  pMessageBarHintText: const Color.fromARGB(255, 66, 191, 221),
  pExportLogsButton: const Color.fromARGB(255, 165, 40, 255),
);

/// If color set is not found then it returns default
ColorSet getColorSetFromName(final String colorSetName) {
  if (colorSetName == playaColorSet.name) {
    return playaColorSet;
  } else if (colorSetName == monochromeColorSet.name) {
    return monochromeColorSet;
  } else if (colorSetName == bubblyColorSet.name) {
    return bubblyColorSet;
  } else {
    return vidarColorSet;
  }
}
