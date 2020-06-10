import 'package:flutter/material.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/widgets/card_layout.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;

  TaskListItem({
    Key key,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timestamp = DayDart.fromString(task.createdAt).format(fm: 'YY-MM-DD');
    var hours = task.hours;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CardLayout(
        color: Colors.white,
        radius: 16,
        child: InkWell(
          onTap: () {
            Router.push(context, Router.TASK_DETAIL_PAGE,
                params: {'oid': this.task.oid});
          },
          child: Padding(
            padding: EdgeInsets.all(0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              leading: task.result == 1
                  ? Icon(
                      Icons.check_circle,
                      color: Colours.color_red,
                    )
                  : Icon(
                      Icons.remove_circle,
                      color: Colours.primary_light,
                    ),
              title: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Gaps.vGap4,
                  Text(
                    "$hours小时挑战 · $timestamp",
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
