import 'package:flutter/foundation.dart';
import '../../domain/entities/field_test_entity.dart';
import '../../domain/usecases/field_test_usecases.dart';
import '../../domain/repositories/field_test_repository.dart';

class FieldTestNotifier extends ChangeNotifier {
  final SaveFieldTestUseCase saveFieldTestUseCase;
  final GetFieldTestHistoryUseCase getFieldTestHistoryUseCase;
  final RunLabBenchmarkUseCase runLabBenchmarkUseCase;
  final FieldTestRepository repository;

  List<FieldTestEntity> _history = [];
  bool _isLoadingHistory = false;
  bool _isBenchmarking = false;
  bool _isSubmitting = false;
  BenchmarkResultEntity? _lastBenchmark;
  String? _errorMessage;

  FieldTestNotifier({
    required this.saveFieldTestUseCase,
    required this.getFieldTestHistoryUseCase,
    required this.runLabBenchmarkUseCase,
    required this.repository,
  });

  List<FieldTestEntity> get history => _history;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get isBenchmarking => _isBenchmarking;
  bool get isSubmitting => _isSubmitting;
  BenchmarkResultEntity? get lastBenchmark => _lastBenchmark;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      _history = await getFieldTestHistoryUseCase(limit: 50);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<BenchmarkResultEntity?> runBenchmark({int sizeKb = 512}) async {
    _isBenchmarking = true;
    notifyListeners();

    try {
      _lastBenchmark = await runLabBenchmarkUseCase(sizeKb: sizeKb);
      _errorMessage = null;
      return _lastBenchmark;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isBenchmarking = false;
      notifyListeners();
    }
  }

  Future<int> submitFieldTest(FieldTestEntity test) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final id = await saveFieldTestUseCase(test);
      await loadHistory();
      return id;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String getExportCsvUrl() => repository.getExportCsvUrl();
}
