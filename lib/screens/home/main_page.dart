import 'package:flutter/material.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/screens/home/task_tab.dart';
import 'package:rebootlist/screens/home/ucenter_tab.dart';

///这个页面是作为首页的最外层的容器，以Tab为基础控制每个item的显示与隐藏
class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  ///tab page
  List<Widget> pages;

  ///底部导航items定义
  final itemNames = [
    _Item('首页', 'assets/icons/ic_home_index_on.png',
        'assets/icons/ic_home_index_off.png'),
    _Item('我的', 'assets/icons/ic_home_user_active.png',
        'assets/icons/ic_home_user_normal.png'),
  ];

  ///底部导航items
  List<BottomNavigationBarItem> itemList;

  ///当前tab index
  int _curTabIndex = 0;

  ///list滚动controller
  ScrollController _scrollViewController;

  ///动画controller
  AnimationController _animController;

  ///动画
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _animController.dispose();
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: [
          _getPagesWidget(0),
          _getPagesWidget(1),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
                position: _animation,
                child: BottomNavigationBar(
                  items: itemList,
                  onTap: (int index) {
                    ///这里根据点击的index来显示，非index的page均隐藏
                    setState(() {
                      _curTabIndex = index;
                    });
                  },
                  //图标大小
                  iconSize: 22,
                  //当前选中的索引
                  currentIndex: _curTabIndex,
                  unselectedItemColor: Colours.text_light,
                  selectedItemColor: Colours.text_primary,
                  type: BottomNavigationBarType.fixed,
                )),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /**
   *
   */

  ///初始化页面
  ///controller
  ///tabpages
  void _initPage() {
    //滑动监听
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      setState(() {
        //list tab如果滚动超过100，隐藏bottom navigation bar
        if (_curTabIndex == 0) {
          double n = _scrollViewController.position.pixels;
          if (n > 100) {
            _animController.forward();
          } else {
            _animController.reverse();
          }
        }
      });
    });

    //动画
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 0.0), end: Offset(0.0, 1.0))
        .animate(_animController);

    //tabs
    if (pages == null) {
      pages = [
        TaskTab(
          scrollViewController: _scrollViewController,
        ),
        UcenterTab()
      ];
    }

    //bottom bar
    if (itemList == null) {
      itemList = itemNames
          .map((item) => BottomNavigationBarItem(
              icon: Image.asset(
                item.normalIcon,
                width: 30.0,
                height: 30.0,
              ),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 10.0, color: Color(0xFF707070)),
              ),
              activeIcon:
                  Image.asset(item.activeIcon, width: 30.0, height: 30.0)))
          .toList();
    }
  }

  ///Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _curTabIndex != index,
      child: TickerMode(
        enabled: _curTabIndex == index,
        child: pages[index],
      ),
    );
  }
}

///导航item model
class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}
