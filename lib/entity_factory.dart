import 'package:rebootlist/models/user_entity.dart';
import 'package:rebootlist/models/log_entity.dart';
import 'package:rebootlist/models/task_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    }  else if (T.toString() == "LogEntity") {
      return LogEntity.fromJson(json) as T;
    } else if (T.toString() == "TaskEntity") {
      return TaskEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}