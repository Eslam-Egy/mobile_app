import '../../domain/entities/field_test_entity.dart';
import '../../domain/repositories/field_test_repository.dart';
import '../datasources/field_test_local_datasource.dart';
import '../datasources/field_test_remote_datasource.dart';
import '../models/field_test_model.dart';

class FieldTestRepositoryImpl implements FieldTestRepository {
  final FieldTestRemoteDataSource remoteDataSource;
  final FieldTestLocalDataSource localDataSource;

  FieldTestRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<int> saveFieldTest(FieldTestEntity test) async {
    final model = FieldTestModel.fromEntity(test);
    // Offline-first: Cache locally first
    await localDataSource.cacheFieldTest(model);

    // Try posting to remote
    try {
      return await remoteDataSource.postTelemetry(model);
    } catch (_) {
      // Saved locally if offline
      return 0;
    }
  }

  @override
  Future<List<FieldTestEntity>> getHistory({int limit = 50}) async {
    try {
      final remoteRecords = await remoteDataSource.fetchTelemetryHistory(limit: limit);
      if (remoteRecords.isNotEmpty) return remoteRecords;
    } catch (_) {
      // Fallback to local cache if offline
    }
    return localDataSource.getCachedFieldTests();
  }

  @override
  Future<BenchmarkResultEntity> runLabBenchmark({int sizeKb = 512}) async {
    return await remoteDataSource.runLabBenchmark(sizeKb: sizeKb);
  }

  @override
  String getExportCsvUrl() => remoteDataSource.getExportCsvUrl();
}
