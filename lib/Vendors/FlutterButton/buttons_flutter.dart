import 'package:flutter/material.dart';

class FlutterTextButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double buttonHeight;
  final double buttonWidth;
  final VoidCallback onTap;

  const FlutterTextButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
