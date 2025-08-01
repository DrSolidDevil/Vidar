import "package:flutter/material.dart";

class BasicButton extends StatelessWidget {
  const BasicButton({
    required this.buttonText,
    required this.textColor,
    required this.buttonColor,
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    this.fontWeight = FontWeight.normal,
    super.key,
  });
  final Color textColor;
  final Color buttonColor;
  final String buttonText;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final FontWeight fontWeight;

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
