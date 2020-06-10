import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rebootlist/res/colors.dart';

class RefreshListView extends StatefulWidget {
  const RefreshListView(
      {Key key,
      @required this.itemCount,
      @required this.itemBuilder,
      @required this.onRefresh,
      this.loadMore,
      this.pageSize: 20,
      this.padding,
      this.itemExtent})
      : super(key: key);

  final RefreshCallback onRefresh;
  final LoadMoreCallback loadMore;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 一页的数量，默认为20
  final int pageSize;
  final EdgeInsetsGeometry padding;
  final double itemExtent;

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class _RefreshListViewState extends State<RefreshListView> {
  ///刷新controller
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: true,
      child: ListView.builder(
          itemCount: widget.itemCount,
          padding: widget.padding,
          itemExtent: widget.itemExtent,
          itemBuilder: (BuildContext context, int index) {
            return widget.itemBuilder(context, index);
          }),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowAlways,
        noDataText: "已经到底了",
        loadingText: "加载中...",
        idleText: "上拉加载",
        failedText: '加载失败,请重试..',
        canLoadingText: "松手开始加载",
        completeDuration: Duration(milliseconds: 500),
      ),
      header: MaterialClassicHeader(
        color: Colours.accent_color,
      ),
      onRefresh: () => _refresh(),
      onLoading: () => _loadMore(),
    );
  }

  void _refresh() {
    if (widget.onRefresh == null) {
      _refreshController.refreshCompleted();
      return;
    }
    widget.onRefresh().then((res) {
      _refreshController.refreshCompleted();
    });
  }

  void _loadMore() {
    if (widget.loadMore == null) {
      return;
    }
    widget.loadMore().then((res) {
      _refreshController.loadComplete();
    });
  }
}
