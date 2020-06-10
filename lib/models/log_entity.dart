import 'package:meta/meta.dart';
import 'package:rebootlist/utils/datetime/DayDart.dart';
import 'package:rebootlist/utils/uuid.dart';

class LogEntity {
  static const String TABLE = "CREATE TABLE Log ("
      "oid TEXT PRIMARY KEY,"
      "text TEXT,"
      "parent TEXT,"
      "createdAt TEXT,"
      "startSpan INTEGER,"
      "progress INTEGER,"
      "endSpan INTEGER,"
      "isCompleted INTEGER NOT NULL DEFAULT 0"
      ")";

  /**
   * task id
   */
  String parent;

  /**
   * 创建时间
   */
  String createdAt;

  /**
   * 距离开始时长（秒）
   */
  int fromSec;

  /**
   * 距离结束时长（秒）
   */
  int toSec;

  /**
   * 动态
   */
  String text;

  /**
   * OID
   */
  String oid;

  /**
   * 进度
   */
  int progress;

  /**
   * 是否完成（备用）
   */
  bool isCompleted;

  String get fromStr {
    var d = (fromSec / 3600 / 24).floor();
    var h = ((fromSec - 3600 * 24 * d) / 3600).floor();
    var m = ((fromSec - 3600 * 24 * d) % 3600 / 60).floor();
    return h == 0
        ? m < 1 ? '00:00' : m > 10 ? '00:$m' : '00:0$m'
        : h > 10 ? m > 10 ? '$h:$m' : '$h:0$m' : m > 10 ? '0$h:$m' : '0$h:0$m';
  }

  String get toStr {
    var d = (toSec / 3600 / 24).floor();
    var h = ((toSec - 3600 * 24 * d) / 3600).floor();
    var m = ((toSec - 3600 * 24 * d) % 3600 / 60).floor();
    return h == 0
        ? m < 1 ? '-00:00' : m > 10 ? '-00:$m' : '-00:0$m'
        : h > 10
            ? m > 10 ? '-$h:$m' : '-$h:0$m'
            : m > 10 ? '-0$h:$m' : '-0$h:0$m';
  }

  LogEntity(this.text,
      {@required this.parent,
      this.createdAt,
      this.fromSec,
      this.toSec,
      String oid,
      int hours,
      this.isCompleted = false}) {
    this.oid = oid ?? Uuid().generateV4();
    var tsec = hours * 60 * 60;
    var tprog = (fromSec / tsec * 100).toInt();
    this.progress = tprog < 1 ? 1 : tprog;
    print('from' + fromSec.toString());
    print('hours' + hours.toString());
    print("progress" + progress.toString());
  }

  LogEntity.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    createdAt = json['createdAt'];
    fromSec = json['startSpan'];
    toSec = json['endSpan'];
    text = json['text'];
    oid = json['oid'];
    progress = json['progress'];
    isCompleted = json['isCompleted'];
  }

  LogEntity.fromMap(Map<String, dynamic> json) {
    parent = json['parent'];
    createdAt = json['createdAt'];
    fromSec = json['startSpan'];
    toSec = json['endSpan'];
    text = json['text'];
    oid = json['oid'];
    progress = json['progress'];
    isCompleted = json['isCompleted'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent'] = this.parent;
    data['createdAt'] = this.createdAt;
    data['startSpan'] = this.fromSec;
    data['endSpan'] = this.toSec;
    data['text'] = this.text;
    data['oid'] = this.oid;
    data['progress'] = this.progress;
    data['isCompleted'] = this.isCompleted;
    return data;
  }

  ///
  /// DEPRECATED
  ///
  LogEntity copy({String text, int isCompleted, int oid, int parent}) {
    return LogEntity(
      text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      oid: oid ?? this.oid,
      parent: parent ?? this.parent,
    );
  }
}
