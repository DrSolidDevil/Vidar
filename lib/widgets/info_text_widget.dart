import "package:flutter/material.dart";
import "package:vidar/utils/settings.dart";

class InfoText extends StatelessWidget {
  const InfoText({required this.text, required this.textWidthFactor, this.fontSize = 20, super.key});

  final String text;
  final double textWidthFactor;
  final double fontSize;

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: Settings.colorSet.primary,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * textWidthFactor,
          child: Text(
            text,
            style: TextStyle(
              color: Settings.colorSet.text,
              fontSize: fontSize,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
