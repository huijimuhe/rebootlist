import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/widgets/animated_floating_button.dart';
import 'package:scoped_model/scoped_model.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage();

  @override
  State<StatefulWidget> createState() {
    return _AddTaskPageState();
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  String taskName;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String createdAt;
  int hours;

  @override
  void initState() {
    super.initState();
    setState(() {
      taskName = '';
      hours = 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState vm) {
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                '新的目标',
                style: TextStyle(color: Colors.black87),
              ),
              centerTitle: false,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black26),
              brightness: Brightness.light,
              backgroundColor: Colors.white,
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (text) {
                      setState(() => taskName = text);
                    },
                    autofocus: true,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '新的挑战是?',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 36.0),
                  ),
                  Gaps.vGap16,
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AnimatedFloatingButton(
              bgColor: null,
              onPress: (hours) {
                addTask(context, vm, hours);
              },
            ));
      },
    );
  }

  void addTask(BuildContext context, AppState vm, int hours) {
    if (taskName.isEmpty) {
      final snackBar = SnackBar(
        content: Text('目标都没有,怎么喝啤酒'),
        backgroundColor: Colours.color_red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      createdAt = DayDart.fromDateTime(DateTime.now()).toISOString();
      vm.addTask(TaskEntity(taskName, createdAt: createdAt, hours: hours));
      Navigator.pop(context);
    }
  }
}
