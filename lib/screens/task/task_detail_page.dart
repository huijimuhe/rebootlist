import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/res/styles.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/screens/task/widgets/log_list_item.dart';
import 'package:rebootlist/screens/task/widgets/task_empty_widget.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/utils/image_utils.dart';
import 'package:rebootlist/widgets/gradient_layout.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:math' as math;

class TaskDetailPage extends StatefulWidget {
  final String oid;

  TaskDetailPage({@required this.oid});

  @override
  State<StatefulWidget> createState() {
    return _TaskDetailPageState();
  }
}

class _TaskDetailPageState extends State<TaskDetailPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  ///标题透明
  double _titleOpacity = 0;
  ScrollController scrollViewController = ScrollController();
  TaskEntity task;
  bool isLoading = false;
  List<LogEntity> logs = [];

  double get screenH => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();

    _initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.color_blue_dark,
        elevation: 0,
        title: AnimatedContainer(
          duration: Duration(milliseconds: 1500),
          child: Text(
            task == null ? '' : task.name,
            style: TextStyle(
              color: Colors.white.withOpacity(_titleOpacity),
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? SpinKitFadingCube(color: Colours.color_blue_light, size: 22.0)
          : task == null ? _buidEmpty() : _buildNestList(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///初始化controllers
  void _initPage() {
    isLoading = true;
    TaskRepository repo = TaskRepository();
    repo.getTask(widget.oid).then((res) {
      setState(() {
        this.task = res;
      });
    }).then((_) => repo.getLogsOfTask(widget.oid).then((res) {
          setState(() {
            this.logs = res;
            this.isLoading = false;
          });
        }));

    scrollViewController.addListener(() {
      setState(() {
        //list tab如果滚动超过100，隐藏bottom navigation bar
        double n = scrollViewController.position.pixels;
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

  Widget _buidEmpty() {
    return Center(
      child: Text(
        '无法加载',
        style: TextStyles.textTaskTitle32,
      ),
    );
  }

  ///
  /// 构建list
  ///
  Widget _buildNestList(BuildContext context) {
    return NestedScrollView(
      controller: scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: _buildTaskHead(context),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 50,
              maxHeight: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImageUtils.getImagePath("bg_header")),
                        fit: BoxFit.fill)),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container()),
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        itemBuilder: (_, index) {
          return LogListItem(
            log: logs[index],
          );
        },
        itemCount: logs.length,
      ),
    );
  }

  ///
  ///task头
  ///
  Widget _buildTaskHead(BuildContext context) {
    var timestamp = task == null
        ? ''
        : DayDart.fromString(task.createdAt).format(fm: 'MM-DD');
    var hours = task == null ? '' : task.hours;
    var result = task.result == 0 ? '挑战失败' : '挑战成功';
    return Container(
      color: Colours.color_blue_dark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              child: Text(
                task.name,
                style: TextStyles.textTaskTitle26,
              ),
            ),
            Gaps.vGap4,
            Text(
              "$hours小时挑战 · $timestamp · $result",
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.white70,
              ),
            ),
            Gaps.vGap16,
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max((minHeight ?? kToolbarHeight), minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
