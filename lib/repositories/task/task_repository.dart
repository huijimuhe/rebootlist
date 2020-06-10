// import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:rebootlist/utils/sp_utils.dart';

import '../../utils/db_provider.dart';
import 'local/task_manager.dart';

class TaskRepository {
  TaskManager _local = TaskManager.getInstance();

  TaskRepository() {}

  Future<List<TaskEntity>> getAllTasks() async {
    var res = await _local.getAllTask();
    return res;
  }

  Future<List<LogEntity>> getLogsOfTask(String tid) async {
    return await _local.getLogsOfTask(tid);
  }

  void setCurTask(TaskEntity task) async {
    if (task == null) {
      SpUtils.remove('cur_task');
    } else {
      SpUtils.putObject("cur_task", task);
    }
  }

  Future<TaskEntity> getCurTask() async {
    var res = await SpUtils.getObject("cur_task");
    return res == null ? null : TaskEntity.fromJson(res);
  }

  Future<TaskEntity> getTask(String oid) async {
   return await _local.getTask(oid);
  }

  void addTask(TaskEntity task) async {
    await _local.insertTask(task);
  }

  void updateTask(TaskEntity task) async {
    await _local.updateTask(task);
  }

  void removeTask(TaskEntity task) async {
    await _local.removeTask(task);
  }

  void removeLog(LogEntity log) async {
    await _local.removeLog(log);
  }

  void addLog(LogEntity log) async {
    await _local.insertLog(log);
  }

  void updateLog(LogEntity log) async {
    await _local.updateLog(log);
  }

}
