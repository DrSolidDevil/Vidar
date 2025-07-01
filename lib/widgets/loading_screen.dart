// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/widgets/loading_text.dart";

class ChatLoadingScreen extends LoadingScreen {
  ChatLoadingScreen(final String contactName, {super.key}) : super(<String>[]) {
    loadingMessages = <String>[
      "Loading",
      "Encrypted",
      "Messages",
      "From",
      contactName,
    ];
  }
  @override
  late final List<String> loadingMessages;
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(this.loadingMessages, {super.key});
  final List<String> loadingMessages;

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 2,
            child: CircularProgressIndicator(
              color: VidarColors.secondaryMetallicViolet,
            ),
          ),
          DecryptingText(
            targets: loadingMessages,
            style: TextStyle(
              color: VidarColors.secondaryMetallicViolet,
              fontSize: SizeConfiguration.loadingFontSize,
            ),
          ),
          /*LoadingText(
            style: TextStyle(color: VidarColors.secondaryMetallicViolet, fontSize: SizeConfiguration.loadingFontSize),
          ),*/
        ],
      ),
    );
  }
}
