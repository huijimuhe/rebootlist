import 'package:flutter/material.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/router/router.dart';

class TaskEmptyWidget extends StatelessWidget {
  bool showAddBtn;

  TaskEmptyWidget(this.showAddBtn);

  @override
  Widget build(BuildContext context) {
    return showAddBtn
        ? InkWell(
            onTap: () {
              Router.push(context, Router.TASK_CREATE_PAGE);
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle_outline,
                    size: 62,
                    color: Colors.black38,
                  ),
                  Gaps.vGap16,
                  Text(
                    '不要怂，就是干！',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Text(
              '管啥都没做',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 22,
              ),
            ),
          );
  }
}
