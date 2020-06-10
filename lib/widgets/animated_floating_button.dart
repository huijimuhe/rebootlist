import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/utils/full_screen_dialog_util.dart';
import 'package:rebootlist/widgets/time_selector_widget.dart';

class AnimatedFloatingButton extends StatefulWidget {
  final Color bgColor;

  final Function(int item) onPress;

  const AnimatedFloatingButton({Key key, this.bgColor, this.onPress})
      : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value) * 56),
          child: Transform.scale(scale: 1 - _animation.value, child: child),
        );
      },
      child: Transform.rotate(
        angle: -pi / 2,
        child: FloatingActionButton(
          onPressed: () async {
            FullScreenDialog.getInstance().showDialog(context,
                TimeSelectorWidget(
              onPress: (hours) {
                _controller.reverse().then((_) {
                  if (hours != 0) {
                    widget.onPress(hours);
                  }
                });
              },
            ));
            _controller.forward();
          },
          child: Transform.rotate(
            angle: pi / 2,
            child: Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colours.color_red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
        ),
      ),
    );
  }
}
