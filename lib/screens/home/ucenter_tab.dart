import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/screens/task/widgets/task_empty_widget.dart';
import 'package:rebootlist/screens/task/widgets/task_list_item.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/SliverAppBarDelegate.dart';
import 'package:rebootlist/utils/image_utils.dart';
import 'package:rebootlist/utils/load_image.dart';
import 'package:rebootlist/widgets/card_layout.dart';
import 'package:rebootlist/widgets/my_flexible_space_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:math' as math;

class UcenterTab extends StatefulWidget {
  UcenterTab();

  @override
  State<StatefulWidget> createState() {
    return _UcenterTabState();
  }
}

class _UcenterTabState extends State<UcenterTab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget child, AppState vm) {
      return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colours.color_blue_dark,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white70,
              ),
              onPressed: () {
                Router.push(context, Router.CONFIG_PAGE);
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            NestedScrollView(
                physics: ClampingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(child: _buildHeader(context, vm)),
                    SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          maxHeight: 19.0,
                          minHeight: 19.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(ImageUtils.getImagePath(
                                        "bg_header2_02")),
                                    fit: BoxFit.fill)),
                            child: Container(),
                          ),
                        ))
                  ];
                },
                body: vm.isLoading
                    ? SpinKitFadingCube(
                        color: Colours.color_blue_light, size: 22.0)
                    : vm.tasks.length == 0
                        ? TaskEmptyWidget(false)
                        : ListView.builder(
                            itemBuilder: (_, index) {
                              return TaskListItem(
                                task: vm.tasks[index],
                              );
                            },
                            itemCount: vm.tasks.length,
                          ))
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context, AppState vm) {
    var len = vm.tasks.length;
    return DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageUtils.getImagePath("bg_header2_01")),
              fit: BoxFit.fill)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "你已尝试$len次重启\n再接再厉!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.vGap4,
            ]),
      ),
    );
  }
}
