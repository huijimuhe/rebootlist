import 'package:flutter/material.dart';
import 'package:rebootlist/res/colors.dart';

class LogProgressIndicator extends StatelessWidget {
  final startedAt;
  final endedAt;
  final _height = 3.0;
  final progress;

  LogProgressIndicator({
    @required this.startedAt,
    @required this.endedAt,
    @required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Text(
            "$startedAt",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(
                    height: _height,
                    color: Colours.color_red,
                  ),
                  AnimatedContainer(
                    height: _height,
                    width: progress * 0.01 * constraints.maxWidth,
                    color: Colours.color_blue_light,
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 8.0),
          child: Text(
            "$endedAt",
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }
}
