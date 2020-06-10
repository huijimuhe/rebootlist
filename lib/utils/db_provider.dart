import 'package:flutter/material.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBProvider {
  static Database _database;

  DBProvider._();

  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, "rebootlist.db");
  }

  ///
  /// 检查数据库是否存在
  ///
  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  ///
  /// 初始化数据库
  ///
  initDB() async {
    String path = await _dbPath;
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("DBProvider:: onCreate()");
      await db.execute(TaskEntity.TABLE);
      await db.execute(LogEntity.TABLE);
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  closeDB() {
    if (_database != null) {
      _database.close();
    }
  }
}
