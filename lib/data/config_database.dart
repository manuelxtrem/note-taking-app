import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/res/constants.dart';

class ConfigDatabase {
  late Box _box;

  final String _lastSyncDateKey = 'last_sync_date_key';
  final String _userKey = 'user_id_key';

  ConfigDatabase() {
    _initialize();
  }

  void _initialize() {
    _box = Hive.box(Constants.configBox);
  }

  DateTime getLastSyncDate() {
    return _box.get(_lastSyncDateKey, defaultValue: DateTime(2000));
  }

  Future setLastSyncDate(DateTime dateTime) async {
    await _box.put(_lastSyncDateKey, dateTime);
  }

  String? getUserId() {
    return _box.get(_userKey, defaultValue: null);
  }

  Future setUserId(String user) async {
    await _box.put(_userKey, user);
  }
}
