import 'package:flutter/material.dart';

class GradientLayout extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final Color shadowColor;

  GradientLayout(
      {@required this.child,
      @required this.color,
      this.radius = 12,
      this.shadowColor = Colors.white30});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: shadowColor,
              offset: Offset(0.0, 2.0),
              blurRadius: 8.0,
              spreadRadius: 0.0),
        ],
        // Box decoration takes a gradient
        gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.3, 0.5, 0.7, 0.9],
            colors: getColorList(color)),
      ),
      curve: Curves.linear,
      child: child,
      duration: Duration(milliseconds: 500),
    );
  }

  List<Color> getColorList(Color color) {
    if (color is MaterialColor) {
      return [
        color[300],
        color[600],
        color[700],
        color[900],
      ];
    } else {
      return List<Color>.filled(4, color);
    }
  }
}
