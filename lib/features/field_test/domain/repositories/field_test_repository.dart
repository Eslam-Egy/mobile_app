import '../entities/field_test_entity.dart';

abstract class FieldTestRepository {
  Future<int> saveFieldTest(FieldTestEntity test);
  Future<List<FieldTestEntity>> getHistory({int limit = 50});
  Future<BenchmarkResultEntity> runLabBenchmark({int sizeKb = 512});
  String getExportCsvUrl();
}
