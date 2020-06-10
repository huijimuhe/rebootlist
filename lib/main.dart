import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/screens/splash/splash_page.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/sp_utils.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor:
        Colors.transparent, //or set color with: Color(0xFF0000FF)
  ));
  WidgetsFlutterBinding.ensureInitialized();

  //share_preference
  await SpUtils.init();

  ///run
  runApp(MyApp());
}

///
///   theme: ThemeData(
//            backgroundColor: Colours.bg_color,
//            accentColor: Colours.accent_color,
//            primaryColor: Colours.color_blue_light,
//            primaryColorDark: Colours.color_blue_dark,
//            primaryColorLight: Colours.primary_light,
//            primaryColorBrightness: Brightness.light,
//            scaffoldBackgroundColor: Colours.bg_color,
//          ),
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppState>(
        model: AppState(),
        child: MaterialApp(
          title: '重启记',
          home: SplashPage(),
        ));
  }
}
