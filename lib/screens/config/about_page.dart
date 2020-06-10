import 'package:flutter/material.dart';
import 'package:rebootlist/res/gaps.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rebootlist/res/colors.dart';
import 'package:rebootlist/res/styles.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget child, AppState model) {
      return Scaffold(
        backgroundColor: Colours.color_blue_dark,
        appBar: AppBar(
          backgroundColor: Colours.color_blue_dark,
          elevation: 0,
          title: Text(
            '关于',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '重记',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                '0.9.1beta',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              ),
              Gaps.vGap50,
              Text('FOR YOU,TIMMY\nMY PRECIOUS LOVE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colours.color_red,
                    fontSize: 34,
                  ))
            ],
          ),
        ),
      );
    });
  }
}
