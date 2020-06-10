
import 'package:flutter/material.dart';
import 'dart:async';

///计时widget
class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;
  final int seconds;

  CountDownWidget({Key key,this.seconds, @required this.onCountDownFinishCallBack})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  int _seconds;

  @override
  void initState() {
    super.initState();
    _seconds=widget.seconds;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds|跳过',
      style: TextStyle(fontSize: 17.0, color: Color(0xFF565656)),
    );
  }

  ///启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if (_seconds <= 1) {
        //结束倒计时
        if(widget.onCountDownFinishCallBack!=null){
          widget.onCountDownFinishCallBack(true);
        }
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}