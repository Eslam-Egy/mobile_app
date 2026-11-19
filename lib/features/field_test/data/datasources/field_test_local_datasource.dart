import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_constants.dart';
import '../models/field_test_model.dart';

abstract class FieldTestLocalDataSource {
  Future<void> cacheFieldTest(FieldTestModel test);
  List<FieldTestModel> getCachedFieldTests();
}

class FieldTestLocalDataSourceImpl implements FieldTestLocalDataSource {
  final SharedPreferences sharedPreferences;

  FieldTestLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheFieldTest(FieldTestModel test) async {
    final list = getCachedFieldTests();
    list.insert(0, test);
    if (list.length > 200) list.removeLast();
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(StorageConstants.keyLocalFieldTests, raw);
  }

  @override
  List<FieldTestModel> getCachedFieldTests() {
    final raw = sharedPreferences.getString(StorageConstants.keyLocalFieldTests);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => FieldTestModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
