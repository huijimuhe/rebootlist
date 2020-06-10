import 'package:flutter/material.dart';

class CardLayout extends StatelessWidget {
  const CardLayout(
      {Key key,
      @required this.child,
      this.color: Colors.white,
      this.radius: 9,
      this.shadowColor: const Color(0x80DCE7FA)})
      : super(key: key);

  final Widget child;
  final Color color;
  final Color shadowColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                offset: Offset(0.0, 2.0),
                blurRadius: 8.0,
                spreadRadius: 0.0),
          ]),
      child: child,
    );
  }
}
