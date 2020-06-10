import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/res/styles.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/screens/task/widgets/log_list_item.dart';
import 'package:rebootlist/screens/task/widgets/task_empty_widget.dart';
import 'package:rebootlist/screens/task/widgets/task_overdue_widget.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/SliverAppBarDelegate.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/utils/datetime/Units.dart';
import 'package:rebootlist/utils/full_screen_dialog_util.dart';
import 'package:rebootlist/utils/image_utils.dart';
import 'package:rebootlist/widgets/count_down_widget.dart';
import 'package:rebootlist/widgets/countdown/slide_countdown_clock.dart';
import 'package:rebootlist/widgets/countdown/slide_countup_clock.dart';
import 'package:rebootlist/widgets/gradient_layout.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskTab extends StatefulWidget {
  final ScrollController scrollViewController;

  TaskTab({this.scrollViewController});

  @override
  State<StatefulWidget> createState() {
    return _TaskTabState();
  }
}

class _TaskTabState extends State<TaskTab> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  ///标题透明
  double _titleOpacity = 0;

  double get screenH => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget w, AppState vm) {
      //构建结构
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colours.color_blue_dark,
          elevation: 0,
          title: AnimatedContainer(
            duration: Duration(milliseconds: 1500),
            child: Text(
              vm.task == null ? '' : vm.task.name,
              style: TextStyle(
                color: Colors.white.withOpacity(_titleOpacity),
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              height: kToolbarHeight - 23,
              width: 85,
              child: vm.task == null
                  ? null
                  : vm.isOverDue()
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colours.color_blue_light,
                                      title: Text(
                                        '再坚持3分钟试试',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      actions: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            vm.endTask(0);
                                            Navigator.pop(context);
                                            Router.push(context,
                                                Router.TASK_CREATE_PAGE);
                                          },
                                          child: Text(
                                            "我就是怂",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "行吧",
                                            style: TextStyle(
                                                color: Colours.color_red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            color: Colours.color_red,
                            textColor: Colors.white,
                            child: Text("认怂"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                        ),
            ),
          ],
        ),
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: vm.isLoading
            ? SpinKitFadingCube(color: Colours.color_blue_light, size: 22.0)
            : vm.task == null
                ? TaskEmptyWidget(true)
                : vm.isOverDue()
                    ? TaskOverdueWidget(vm)
                    : _buildBody(context, vm),
        floatingActionButtonLocation: _CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endDocked,
            -5,
            kBottomNavigationBarHeight * -2),
        floatingActionButton: vm.task == null
            ? null
            : vm.isOverDue()
                ? null
                : Builder(
                    builder: (BuildContext context) {
                      return FloatingActionButton(
                        child: Icon(Icons.add),
                        backgroundColor: Colours.color_red,
                        onPressed: () {
                          Router.push(context, Router.LOG_CREATE_PAGE);
                        },
                      );
                    },
                  ),
      );
    });
  }

  ///初始化controllers
  void _initPage() async {
    widget.scrollViewController.addListener(() {
      setState(() {
        //list tab如果滚动超过100，隐藏bottom navigation bar
        double n = widget.scrollViewController.position.pixels;
        if (n > 100) {
          _titleOpacity = 1;
        } else if (n > 40 && n < 100) {
          _titleOpacity = n / 100;
        } else {
          _titleOpacity = 0;
        }
      });
    });
  }

  ///
  /// 构建body
  ///
  Widget _buildBody(BuildContext context, AppState vm) {
    var timestamp = vm.task == null
        ? ''
        : DayDart.fromString(vm.task.createdAt).format(fm: 'MM-DD');
    var hours = vm.task == null ? '' : vm.task.hours;
    return NestedScrollView(
      controller: widget.scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return _buildHeader(context, vm);
      },
      body: ListView.builder(
        itemBuilder: (_, index) {
          return LogListItem(
            log: vm.logs[index],
          );
        },
        itemCount: vm.logs.length,
      ),
    );
  }

  ///
  ///task头
  ///
  List<Widget> _buildHeader(BuildContext context, AppState vm) {
    var timestamp = vm.task == null
        ? ''
        : DayDart.fromString(vm.task.createdAt).format(fm: 'MM-DD');
    var hours = vm.task == null ? '' : vm.task.hours;
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          color: Colours.color_blue_dark,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  child: Text(
                    vm.task.name,
                    style: TextStyles.textTaskTitle26,
                  ),
                ),
                Gaps.vGap4,
                Text(
                  "$hours小时挑战 · $timestamp",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white70,
                  ),
                ),
                Gaps.vGap16,
              ],
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          minHeight: 50,
          maxHeight: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageUtils.getImagePath("bg_header")),
                    fit: BoxFit.fill)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SlideCountupClock(
                          duration: Duration(seconds: vm.getFromSpan()),
                          slideDirection: SlideDirection.Up,
                          separator: ":",
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          onDone: () {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Clock 1 finished')));
                          },
                        ),
                        Text(
                          "已坚持",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SlideCountdownClock(
                            duration: Duration(seconds: vm.getToSpan()),
                            //
                            slideDirection: SlideDirection.Down,
                            separator: ":",
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            onDone: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colours.color_blue_light,
                                      title: Text(
                                        '干的漂亮！',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      actions: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            vm.endTask(1);
                                            Navigator.pop(context);
                                            Router.push(context,
                                                Router.TASK_CREATE_PAGE);
                                          },
                                          child: Text(
                                            "棒棒哒",
                                            style: TextStyle(
                                                color: Colours.color_red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                          Text(
                            "距离结束",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    ];
  }
}

class _CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  _CustomFloatingActionButtonLocation(
      this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
