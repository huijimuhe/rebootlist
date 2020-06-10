import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/repositories/task/task_repository.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/utils/datetime/Units.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskState extends Model {
  List<LogEntity> _logs = [];
  List<TaskEntity> _tasks = [];

  List<LogEntity> get logs => _logs;

  List<TaskEntity> get tasks => _tasks;

  TaskEntity _curTask;

  TaskEntity get task => _curTask;

  TaskRepository _repo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int totalSuc;

  int totalFail;

  Future initTaskState() async {
    _isLoading = true;
    _repo = TaskRepository();
    _curTask = await _repo.getCurTask();
    if (_curTask != null) {
      _logs = await _repo.getLogsOfTask(_curTask.oid);
    }
    _tasks = await _repo.getAllTasks();
    _isLoading = false;
    notifyListeners();
  }

  ///
  /// 添加task
  ///
  void addTask(TaskEntity task) {
    _curTask = task;
    _tasks.add(task);
    _repo.addTask(task);
    _repo.setCurTask(task);
    notifyListeners();
  }

  ///
  /// 更新task
  ///
  void updateTask(TaskEntity task) {
    _curTask = task;
    var oldT = _tasks.firstWhere((it) => it.oid == task.oid);
    var replaceIndex = _tasks.indexOf(oldT);
    _tasks.replaceRange(replaceIndex, replaceIndex + 1, [task]);
    _repo.updateTask(task);
    notifyListeners();
  }

  ///
  /// 更新task
  ///
  void endTask(int result) {
    _curTask.result = result;
    _curTask.isDone = true;

    var oldT = _tasks.firstWhere((it) => it.oid == task.oid);
    var replaceIndex = _tasks.indexOf(oldT);
    _tasks.replaceRange(replaceIndex, replaceIndex + 1, [task]);
    _repo.updateTask(task);

    _logs.clear();
    _curTask = null;
    _repo.setCurTask(null);
    notifyListeners();
  }

  Future<TaskEntity> getTask(String oid) async {
    var res = await _repo.getTask(oid);
    _isLoading = false;
    notifyListeners();
    return res;
  }

  void removeTask(TaskEntity task) async {
    _tasks.removeWhere((it) => it.oid == task.oid);
    await _repo.removeTask(task);
    notifyListeners();
  }

  Future<List<LogEntity>> getLogsOfTask(String tid) async {
    var res = await _repo.getLogsOfTask(tid);
    _isLoading = false;
    notifyListeners();
    return res;
  }

  void addLog(String text) async {
    LogEntity log = LogEntity(text,
        parent: _curTask.oid,
        createdAt: DayDart.fromDateTime(DateTime.now()).toISOString(),
        fromSec: DayDart.fromString(_curTask.createdAt).fromSec(),
        toSec: DayDart.fromString(_curTask.createdAt)
            .add(_curTask.hours, Units.H)
            .toSec(),
        hours: _curTask.hours,
        isCompleted: true);
    _logs.add(log);
    await _repo.addLog(log);
    notifyListeners();
  }

  void updateLog(LogEntity log) {
    var oldT = _logs.firstWhere((it) => it.oid == log.oid);
    var replaceIndex = _logs.indexOf(oldT);
    _logs.replaceRange(replaceIndex, replaceIndex + 1, [log]);
    _repo.updateLog(log);
    notifyListeners();
  }

  void removeLog(LogEntity log) {
    _logs.removeWhere((it) => it.oid == log.oid);
    _repo.removeLog(log);
    notifyListeners();
  }

  int getFromSpan() {
    return DayDart.fromString(_curTask.createdAt).fromSec();
  }

  /**
   * 剩余时间
   */
  int getToSpan() {
    return DayDart.fromString(_curTask.createdAt)
        .add(_curTask.hours, Units.H)
        .toSec();
  }

  ///
  /// 检查任务是否已到期
  ///
  bool isOverDue() {
    return _curTask != null &&
        DayDart.fromString(_curTask.createdAt)
            .add(_curTask.hours, Units.H)
            .isBefore(DayDart.fromDateTime(DateTime.now()));
  }
}
