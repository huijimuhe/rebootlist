import 'package:rebootlist/utils/sp_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigState extends Model {
  bool isUsed = false;

  void initConfigState() async {
    isUsed = await SpUtils.getBool('isUsed', defValue: false);
    notifyListeners();
  }

  void used() {
    isUsed = true;
    SpUtils.putBool('is_used', true);
    notifyListeners();
  }
}
