
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:rebootlist/widgets/countdown/slide_countdown_clock.dart';

class SlideCountupClock extends StatefulWidget {
  /// The amount of time until the event and `onDone` is called.
  final Duration duration;

  /// The style of text used for the digits
  final TextStyle textStyle;

  /// The style used for seperator between digits. I.e. `:`, `.`, `,`.
  final TextStyle separatorTextStyle;

  /// The character(s) to display between the hour divisions: `10 : 20`
  final String separator;

  /// The decoration to place on the container
  final BoxDecoration decoration;

  /// The direction in which the numerals move out in and out of view.
  final SlideDirection slideDirection;

  /// A callback that is called when the [duration] reaches 0.
  final VoidCallback onDone;

  /// The padding around the widget.
  final EdgeInsets padding;

  /// True for a label that needs added padding between characters.
  final bool tightLabel;

  SlideCountupClock({
    Key key,
    @required this.duration,
    this.textStyle: const TextStyle(
      fontSize: 30,
      color: Colors.black,
    ),
    this.separatorTextStyle,
    this.decoration,
    this.tightLabel: false,
    this.separator: "",
    this.slideDirection: SlideDirection.Down,
    this.onDone,
    this.padding: EdgeInsets.zero,
  }) : super(key: key);

  @override
  SlideCountupClockState createState() => SlideCountupClockState(duration);
}

class SlideCountupClockState extends State<SlideCountupClock> {
  SlideCountupClockState(Duration duration) {
    timeLeft = duration;
  }

  bool isInit = false;
  Duration timeLeft;
  Stream<DateTime> initStream;
  Stream<DateTime> timeStream;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.duration;
    _init();
  }

  @override
  void didUpdateWidget(SlideCountupClock oldWidget) {
    super.didUpdateWidget(oldWidget);
//    print('didUpdateWidget trigger');
//    try {
//      timeLeft = widget.duration;
//    } catch (ex) {}
//    if (!isInit) {
//      _init();
//      isInit = true;
//    }
  }

  void _init() {
    var time = DateTime.now();
    initStream = Stream<DateTime>.periodic(Duration(milliseconds: 1000), (_) {
      timeLeft += Duration(seconds: 1);
      return time;
    });
    timeStream = initStream.take(timeLeft.inSeconds).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildDigit(
          timeStream,
              (DateTime time) => (timeLeft.inHours % 24) ~/ 10,
              (DateTime time) => (timeLeft.inHours % 24) % 10,
          DateTime.now(),
          "Hours",
        ),
        _buildSpace(),
        (widget.separator.isNotEmpty) ? _buildSeparator() : SizedBox(),
        _buildSpace(),
        _buildDigit(
          timeStream,
              (DateTime time) => (timeLeft.inMinutes % 60) ~/ 10,
              (DateTime time) => (timeLeft.inMinutes % 60) % 10,
          DateTime.now(),
          "minutes",
        ),
        _buildSpace(),
        (widget.separator.isNotEmpty) ? _buildSeparator() : SizedBox(),
        _buildSpace(),
        _buildDigit(
          timeStream,
              (DateTime time) => (timeLeft.inSeconds % 60) ~/ 10,
              (DateTime time) => (timeLeft.inSeconds % 60) % 10,
          DateTime.now(),
          "seconds",
        )
      ],
    );
  }

  Widget _buildSpace() {
    return SizedBox(width: 3);
  }

  Widget _buildSeparator() {
    return Text(
      widget.separator,
      style: widget.separatorTextStyle ?? widget.textStyle,
    );
  }

  Widget _buildDigit(
      Stream<DateTime> timeStream,
      Function tensDigit,
      Function onesDigit,
      DateTime startTime,
      String id,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: widget.decoration,
              padding: widget.tightLabel
                  ? EdgeInsets.zero
                  : EdgeInsets.only(left: 3),
              child: Digit<int>(
                padding: widget.padding,
                itemStream: timeStream.map<int>(tensDigit),
                initValue: tensDigit(startTime),
                id: id,
                decoration: widget.decoration,
                slideDirection: widget.slideDirection,
                textStyle: widget.textStyle,
              ),
            ),
            Container(
              decoration: widget.decoration,
              padding: widget.tightLabel
                  ? EdgeInsets.zero
                  : EdgeInsets.only(right: 3),
              child: Digit<int>(
                padding: widget.padding,
                itemStream: timeStream.map<int>(onesDigit),
                initValue: onesDigit(startTime),
                decoration: widget.decoration,
                slideDirection: widget.slideDirection,
                textStyle: widget.textStyle,
                id: id,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
