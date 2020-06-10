import 'package:flutter/material.dart';
import 'package:rebootlist/utils/uuid.dart';

class TaskEntity {
  /**
   * 数据库
   */
  static const String TABLE = "CREATE TABLE Task ("
      "oid TEXT PRIMARY KEY,"
      "name TEXT,"
      "remark TEXT,"
      "createdAt TEXT,"
      "endedAt TEXT,"
      "hours INTEGER,"
      "isDone INTEGER NOT NULL DEFAULT 0,"
      "result INTEGER NOT NULL DEFAULT 0"
      ")";

  /**
   * 创建时间
   */
  String createdAt;

  /**
   * 结束时间
   */
  String endedAt;

  /**
   * 目标
   */
  String name;

  /**
   * 结束备注
   */
  String remark;

  /**
   * OID
   */
  String oid;

  /**
   * 时长
   */
  int hours;

  /**
   * 是否结束
   */
  bool isDone;

  /**
   * 结束标示0未完成1完成
   */
  int result;

  TaskEntity(
    this.name, {
    this.result=0,
    this.createdAt,
    this.endedAt,
    this.isDone = false,
    this.hours,
    String oid,
  }) : this.oid = oid ?? Uuid().generateV4();

  TaskEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    createdAt = json['createdAt'];
    endedAt = json['endedAt'];
    name = json['name'];
    oid = json['oid'];
    isDone = json['isDone'];
    hours = json['hours'];
    remark = json['remark'];
  }

  TaskEntity.fromMap(Map<String, dynamic> json) {
    result = json['result'];
    createdAt = json['createdAt'];
    endedAt = json['endedAt'];
    name = json['name'];
    oid = json['oid'];
    isDone = json['isDone'] == 1;
    hours = json['hours'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['createdAt'] = this.createdAt;
    data['endedAt'] = this.endedAt;
    data['name'] = this.name;
    data['oid'] = this.oid;
    data['isDone'] = this.isDone;
    data['hours'] = this.hours;
    data['remark'] = this.remark;
    return data;
  }
}
