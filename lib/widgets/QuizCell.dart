import 'package:flutter/material.dart';

class QuizCell extends StatelessWidget {
  final String text;
  final int folderCount;

  const QuizCell({
    Key? key,
    required this.text,
    required this.folderCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Color(0xFFB6E1F4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        shadows: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 2,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 55,
            child: SizedBox(
              width: 170,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 0.07,
                  letterSpacing: -0.40,
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 124,
            child: Container(
              width: 141,
              height: 92,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFF8F8F8), Color(0x00D9D9D9)],
                ),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 142,
            child: Container(
              width: 170,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(children: [
                      // Your folder icons or content can be added here
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sub Folders : $folderCount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 10,
                      fontFamily: 'Univers LT Std',
                      fontWeight: FontWeight.w400,
                      height: 0.15,
                      letterSpacing: -0.40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
