import "package:flutter/material.dart";

class BasicButton extends StatefulWidget {
  const BasicButton({
    required this.buttonText,
    required this.textColor,
    required this.buttonColor,
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    super.key,
  });
  final Color textColor;
  final Color buttonColor;
  final String buttonText;
  final Function onPressed;
  final double width;
  final double height;

  @override
  _BasicButtonState createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  _BasicButtonState();

  late final Color textColor;
  late final Color buttonColor;
  late final String buttonText;
  late final Function onPressed;
  late final double width;
  late final double heigth;
  
  @override
  void initState() {
    super.initState();
    textColor = widget.textColor;
    buttonColor = widget.buttonColor;
    buttonText = widget.buttonText;
    onPressed = widget.onPressed;
    width = widget.width;
    heigth = widget.height;
  }

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Container(
        width: width,
        height: heigth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24, color: textColor),
        ),
      ),
    );

    /*Material(
      color: buttonColor,
      child: InkWell(
        child: SizedBox(
          width: 100,
          height: 50,
          child: Container(
            alignment: Alignment.center,
            color: buttonColor,
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24, color: textColor),
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );*/
  }
}
