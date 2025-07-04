import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  EdgeInsetsGeometry? margin;
  String title;
  String? fontFamily;
  int? maxLines;
  double height;
  double fontSize;
  Color color;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  TextDecoration? decoration;
  TextOverflow? overflow;

  NormalText({
    super.key,
    this.margin,
    required this.title,
    this.fontFamily,
    this.maxLines,
    this.height = 1.5,
    required this.fontSize,
    required this.color,
    this.fontWeight,
    this.textAlign,
    this.decoration,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: fontFamily,
          height: height,
          fontSize: fontSize,
          letterSpacing: -0.2,
          color: color,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: color,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
      ),
    );
  }
}
