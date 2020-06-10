import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/utils/db_provider.dart';
import 'dart:async';
import 'package:synchronized/synchronized.dart';

/**
 * 本地缓存
 */
class TaskManager {
  DBProvider _db;

  static TaskManager _singleton;
  static Lock _lock = Lock();

  static TaskManager getInstance() {
    if (_singleton == null) {
      _lock.synchronized(() {
        if (_singleton == null) {
          var singleton = TaskManager._();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  TaskManager._() {
    _db = DBProvider.db;
  }

  /// ////////
  ///
  /// logs
  ///
  /// ///////
  Future<List<LogEntity>> getLogsOfTask(String tid) async {
    final db = await _db.database;
    var result = await db.query('Log', where: 'parent = ?', whereArgs: [tid]);
    return result.map((it) => LogEntity.fromMap(it)).toList();
  }

  insertBulkLog(List<LogEntity> Logs) async {
    final db = await _db.database;
    Logs.forEach((it) async {
      var res = await db.insert("Log", it.toJson());
      print("Log ${it.oid} = $res");
    });
  }

  Future<int> insertLog(LogEntity Log) async {
    final db = await _db.database;
    return db.insert('Log', Log.toJson());
  }

  Future<int> updateLog(LogEntity Log) async {
    final db = await _db.database;
    return db
        .update('Log', Log.toJson(), where: 'oid = ?', whereArgs: [Log.oid]);
  }

  Future<int> removeLog(LogEntity Log) async {
    final db = await _db.database;
    return db.delete('Log', where: 'oid = ?', whereArgs: [Log.oid]);
  }

  /// ////////
  ///
  /// tasks
  ///
  /// ///////

  Future<TaskEntity> getTask(String oid) async {
    final db = await _db.database;
    var result = await db.query('Task', where: 'oid = ?', whereArgs: [oid]);
    var res = result.first;
    return res != null ? TaskEntity.fromMap(res) : null;
  }

  Future<List<TaskEntity>> getAllTask() async {
    final db = await _db.database;
    var result = await db.query('Task');
    return result.map((it) => TaskEntity.fromMap(it)).toList();
  }

  insertBulkTask(List<TaskEntity> tasks) async {
    final db = await _db.database;
    tasks.forEach((it) async {
      var res = await db.insert("Task", it.toJson());
      print("Task ${it.oid} = $res");
    });
  }

  Future<int> insertTask(TaskEntity task) async {
    final db = await _db.database;
    return db.insert('Task', task.toJson());
  }

  Future<int> updateTask(TaskEntity task) async {
    final db = await _db.database;
    return db
        .update('Task', task.toJson(), where: 'oid = ?', whereArgs: [task.oid]);
  }

  Future<void> removeTask(TaskEntity task) async {
    final db = await _db.database;
    return db.transaction<void>((txn) async {
      await txn.delete('Log', where: 'parent = ?', whereArgs: [task.oid]);
      await txn.delete('Task', where: 'oid = ?', whereArgs: [task.oid]);
    });
  }
}
