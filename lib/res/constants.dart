import 'package:flutter/material.dart';

class Constants {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = bool.fromEnvironment("dart.vm.product");

  static const String baseUrl = 'http://10.5.9.54/maliao-api/public/api';//'http://maliao.jusgo.cn/api';

  static const int page_size = 20;
  static const String JPUSH_APP = '';
  static const String JPUSH_SECRET = '';

  static const double MARGIN_LEFT = 13.0;
  static const double MARGIN_RIGHT = 13.0;
  static const String ASSETS_IMG = 'assets/icons/';

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String key_guide = 'key_guide';
  static const String phone = 'phone';
  static const String access_Token = 'accessToken';
  static const String account = 'account_info';
  static const String refresh_Token = 'refreshToken';
  static const String current_task = 'currentTask';
  static const String current_node = 'currentNode';
  static const String first_time_use = "firstTimeUse";
  static const String first_time_guide = "firstTimeGuide";

  ///分页第一页的index
  static const int first_list_page = 0;


  ///oss bucket
  static const String OSS_BUCKET = 'huijimuhe-maliao-open';
  static const String OSS_DOMAIN = 'oss-cn-beijing.aliyuncs.com';
}
