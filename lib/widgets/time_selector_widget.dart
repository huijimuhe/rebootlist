import 'dart:math';

import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebootlist/res/colors.dart';

class TimeSelectorWidget extends StatefulWidget {
  final VoidCallback onExit;

  final Function(int item) onPress;

  TimeSelectorWidget({this.onExit, this.onPress});

  @override
  _TimeSelectorWidgetState createState() => _TimeSelectorWidgetState();
}

class _TimeSelectorWidgetState extends State<TimeSelectorWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  List<int> _children = [24, 36, 48, 60, 72];
  int _selectHour = 0;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxSize = max(size.height, size.width);
    final minSize = min(size.height, size.width);
    final circleSize = minSize;
    final Offset circleOrigin = Offset((size.width - circleSize) / 2, 0);

    return WillPopScope(
      onWillPop: () {
        dismiss(context, _controller);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          print('dismiss');
          if (_selectHour == 0) {
            dismiss(context, _controller);
          } else {
            doExit(context, _controller);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0),
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 20,
                  left: size.width / 2 - 28,
                  child: AnimatedBuilder(
                      animation: _animation,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.2),
                            shape: BoxShape.circle),
                      ),
                      builder: (ctx, child) {
                        return Transform.scale(
                          scale: (max(size.height, size.width) / 28) *
                              (_animation.value),
                          child: child,
                        );
                      }),
                ),
                Positioned(
                  left: circleOrigin.dx,
                  top: circleOrigin.dy,
                  child: AnimatedBuilder(
                    animation: _animation,
                    child: CircleList(
                      initialAngle: pi / 2,
                      origin: Offset(0, -min(size.height, size.width) / 2 + 20),
                      showInitialAnimation: true,
                      children: List.generate(_children.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectHour = _children[index];
                            });
                          },
                          child: Text(
                            _children[index].toString() + "H",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        );
                      }),
                      innerCircleColor: Theme.of(context).primaryColorLight,
                      outerCircleColor: Theme.of(context).primaryColorDark,
                      centerWidget: GestureDetector(
                          onTap: () {
                            doExit(context, _controller);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              color: _selectHour == 0
                                  ? Colors.grey
                                  : Colours.color_red,
                              shape: BoxShape.circle,
                            ),
                            child: _selectHour == 0
                                ? Container(
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  )
                                : Container(
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                          )),
                    ),
                    builder: (ctx, child) {
                      return Transform.translate(
                          offset: Offset(
                              0,
                              MediaQuery.of(context).size.height -
                                  (_animation.value) * circleSize),
                          child: Transform.scale(
                              scale: _animation.value, child: child));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dismiss(BuildContext context, AnimationController controller) {
    controller.reverse().then((r) {
      Navigator.of(context).pop();
    });
  }

  void doExit(BuildContext context, AnimationController controller) {
    controller.reverse().then((r) {
      Navigator.of(context).pop();
    });
    widget?.onPress(_selectHour);
  }
}
