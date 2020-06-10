import 'package:flutter/material.dart';
import 'package:rebootlist/res/styles.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:rebootlist/utils/screen_utils.dart';
import 'package:rebootlist/widgets/count_down_widget.dart';
import 'package:scoped_model/scoped_model.dart';

///打开APP首页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _duration = 2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState model) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              _buildSplash(context, model),
              Offstage(
                child: Container(
                  child: _buildIntro(context),
                ),
                offstage: model.isUsed ? model.isUsed : false,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSplash(BuildContext context, AppState vm) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Spacer(flex: 5),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '重记',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      Text(
                        '每次重启,都是历练',
                        style: TextStyles.textGray10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment(1.0, 0.0),
                child: Container(
                  margin: const EdgeInsets.only(right: 30.0, top: 20.0),
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                  child: CountDownWidget(
                      seconds: _duration,
                      onCountDownFinishCallBack: (res) {
                        //判断跳转页面
                        _jumpPage(context);
                        vm.used();
                      }),
                  decoration: BoxDecoration(
                      color: Color(0xffEDEDED),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
            ],
          ))
        ],
      ),
      width: ScreenUtils.screenW(context),
      height: ScreenUtils.screenH(context),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Center(
      child: Text('不要怂,就是干！',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 22,

          )),
    );
  }
}

///
///跳转页面
///更新是否第一次加载
///
void _jumpPage(context) {
  Router.push(context, Router.HOME_PAGE, clearStack: true);
}
