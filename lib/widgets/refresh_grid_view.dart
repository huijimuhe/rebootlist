import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rebootlist/res/colors.dart';

class RefreshGridView extends StatefulWidget {
  const RefreshGridView(
      {Key key,
      @required this.itemCount,
      @required this.itemBuilder,
      @required this.onRefresh,
      this.loadMore,
      this.pageSize: 20,
      this.padding,
      this.crossAxisCount: 2,
      this.itemExtent})
      : super(key: key);

  final RefreshCallback onRefresh;
  final LoadMoreCallback loadMore;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;

  /// 一页的数量，默认为20
  final int pageSize;
  final EdgeInsetsGeometry padding;
  final double itemExtent;

  @override
  _RefreshGridViewState createState() => _RefreshGridViewState();
}

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class _RefreshGridViewState extends State<RefreshGridView> {
  ///刷新controller
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: widget.loadMore!=null,
      enablePullDown: widget.onRefresh!=null,
      child: GridView.builder(
          itemCount: widget.itemCount,
          padding: widget.padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: 4,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 5),
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
      header:  MaterialClassicHeader(
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
