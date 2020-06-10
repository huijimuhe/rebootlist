import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rebootlist/state/config_state.dart';
import 'package:rebootlist/state/task_state.dart';
import 'package:scoped_model/scoped_model.dart';

class AppState extends Model with TaskState, ConfigState {
  Timer _timer;
  int _seconds;

  AppState() {
    initConfigState();
    initTaskState();
    if(task!=null){
      _startTimer();
    }
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
    notifyListeners();
  }

  @override
  void removeListener(listener) {
    super.removeListener(listener);
  }

  static AppState of(BuildContext context) => ScopedModel.of<AppState>(context);

  ///启动倒计时的计时器。
  void _startTimer() {

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        //结束倒计时
//        if (widget.onCountDownFinishCallBack != null) {
//          widget.onCountDownFinishCallBack(true);
//        }
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
