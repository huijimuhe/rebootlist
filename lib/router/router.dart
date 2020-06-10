import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rebootlist/screens/config/about_page.dart';
import 'package:rebootlist/screens/home/main_page.dart';
import 'package:rebootlist/screens/task/add_log_page.dart';
import 'package:rebootlist/screens/task/add_task_page.dart';
import 'package:rebootlist/screens/task/task_detail_page.dart';
import 'package:rebootlist/screens/task/task_list_page.dart';

class Router {
  static const HOME_PAGE = 'app://main';
  static const TASK_CREATE_PAGE = 'app://task.create';
  static const TASK_LIST_PAGE = 'app://task.list';
  static const TASK_DETAIL_PAGE = 'app://task.show';
  static const LOG_CREATE_PAGE = 'app://log.create';
  static const CONFIG_PAGE = 'app://config.about';

  Widget _router(String url, dynamic params) {
    String pageId = _pageIdMap[url];
    return _getPage(pageId, params);
  }

  Map<String, dynamic> _pageIdMap = <String, dynamic>{
    'app/': 'ContainerPageWidget',
  };

  Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
//      return WebViewPage(url, params: params);
    } else {
      switch (url) {
        case HOME_PAGE:
          return MainPage();
        case TASK_LIST_PAGE:
          return TaskListPage();
        case TASK_CREATE_PAGE:
          return AddTaskPage();
        case TASK_DETAIL_PAGE:
          return TaskDetailPage(
            oid: params['oid'],
          );
        case LOG_CREATE_PAGE:
          return AddLogPage();
        case CONFIG_PAGE:
          return AboutPage();
      }
    }
    return null;
  }

  Router.push(BuildContext context, String url,
      {dynamic params, bool replace: false, bool clearStack: false}) {
    if (clearStack) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return _getPage(url, params);
      }), (route) => route == null);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return _getPage(url, params);
      }));
    }
  }

  ///带参数返回
  Router.pushResult(BuildContext context, String url, Function function,
      {dynamic params}) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    })).then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }
}
