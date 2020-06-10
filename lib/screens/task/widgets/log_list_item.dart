import 'package:flutter/material.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/res/styles.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/widgets/card_layout.dart';
import 'package:rebootlist/widgets/gradient_layout.dart';
import 'package:rebootlist/widgets/log_progress_indicator.dart';

typedef SwipedCallback = Future<void> Function();

class LogListItem extends StatelessWidget {
  final LogEntity log;

  LogListItem({
    Key key,
    @required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('log progress:'+log.progress.toString());
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      child: CardLayout(
        color: Colors.white,
        radius: 16,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                log.text,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Gaps.vGap12,
              LogProgressIndicator(
                startedAt: log.fromStr,
                endedAt: log.toStr,
                progress: log.progress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
