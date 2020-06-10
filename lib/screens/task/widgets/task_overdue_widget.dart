import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/state/app_state.dart';

class TaskOverdueWidget extends StatelessWidget {
  AppState vm;

  TaskOverdueWidget(this.vm);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.color_blue_dark,
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            '时间已到,你的目标办到了么?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.vGap50,
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  vm.endTask(0);
                  Router.push(context, Router.TASK_CREATE_PAGE);
                },
                child: Text(
                  "怂了",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
              Gaps.hGap16,
              InkWell(
                onTap: () {
                  vm.endTask(1);
                  Router.push(context, Router.TASK_CREATE_PAGE);
                },
                child: Text(
                  "毫无压力",
                  style: TextStyle(
                      color: Colours.color_red,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
