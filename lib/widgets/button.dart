import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final double height;
  final double width;
  final Function onPressed;
  final String text;

  CustomButtom(
      {@required this.height,
      @required this.width,
      @required this.onPressed,
      this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.black)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.5),
          ),
        ),
      ),
    );
  }
}
