import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:scoped_model/scoped_model.dart';

class AddLogPage extends StatefulWidget {
  AddLogPage();

  @override
  State<StatefulWidget> createState() {
    return _AddLogPageState();
  }
}

class _AddLogPageState extends State<AddLogPage> {
  String text;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String createdAt;
  int hours;

  @override
  void initState() {
    super.initState();
    setState(() {
      text = '';
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
              '记日志',
              style: TextStyle(color: Colors.black87),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() => this.text = text);
                  },
                  autofocus: true,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '为了目标你做了什么...',
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
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton(
                heroTag: 'fab_new_card',
                child: Icon(Icons.check),
                backgroundColor: Colours.color_red,
                onPressed: () {
                  addLog(context, vm);
                },
              );
            },
          ),
        );
      },
    );
  }

  void addLog(BuildContext context, AppState vm) {
    if (this.text.isEmpty) {
      final snackBar = SnackBar(
        content: Text('要记东西'),
        duration: Duration(seconds: 1),
        backgroundColor: Colours.color_red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      vm.addLog(text);
      Navigator.pop(context);
    }
  }
}
