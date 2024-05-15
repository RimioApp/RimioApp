import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.radius,
    required this.text,
    required this.textColor,
    required this.shadow,
    required this.colorShadow,
    this.onTap,
    required this.fontSize});

  final double height;
  final double width;
  final Color color;
  final Color textColor;
  final double radius;
  final String text;
  final double fontSize;
  final double shadow;
  final Color colorShadow;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: const Alignment(0,0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: shadow,
              color: colorShadow,
            )
          ],
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: fontSize),),
      ),
    );
  }
}
