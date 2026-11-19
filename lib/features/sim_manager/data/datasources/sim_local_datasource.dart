import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_constants.dart';
import '../models/test_sim_model.dart';

abstract class SimLocalDataSource {
  List<TestSimModel> getSimCards();
  Future<void> saveSimCards(List<TestSimModel> sims);
}

class SimLocalDataSourceImpl implements SimLocalDataSource {
  final SharedPreferences sharedPreferences;

  SimLocalDataSourceImpl({required this.sharedPreferences}) {
    _ensureDefaultSims();
  }

  @override
  List<TestSimModel> getSimCards() {
    final raw = sharedPreferences.getString(StorageConstants.keySimCards);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => TestSimModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveSimCards(List<TestSimModel> sims) async {
    final raw = jsonEncode(sims.map((s) => s.toJson()).toList());
    await sharedPreferences.setString(StorageConstants.keySimCards, raw);
  }

  void _ensureDefaultSims() {
    final existing = getSimCards();
    if (existing.isEmpty) {
      final defaults = [
        TestSimModel(
          id: 'sim-001',
          cardName: 'Lab Phone A (Caller)',
          imsi: '001010000000001',
          extension: '1001',
          cardType: 'Programmable USIM',
          notes: 'Configured with pySim-shell for OpenBTS-UMTS test PLMN 001/01',
          createdAt: DateTime.now(),
        ),
        TestSimModel(
          id: 'sim-002',
          cardName: 'Lab Phone B (Callee)',
          imsi: '001010000000002',
          extension: '1002',
          cardType: 'Programmable USIM',
          notes: 'Allocated for CS voice loopback and SMS termination testing',
          createdAt: DateTime.now(),
        ),
      ];
      saveSimCards(defaults);
    }
  }
}
