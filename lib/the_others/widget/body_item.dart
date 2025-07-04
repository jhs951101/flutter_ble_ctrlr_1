import 'package:flutter/material.dart';

class BodyItem extends StatelessWidget {
  Widget child;
  double left;
  double right;
  double top;
  double bottom;

  BodyItem({
    super.key,
    required this.child,
    this.left = 15,
    this.right = 15,
    this.top = 10,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
