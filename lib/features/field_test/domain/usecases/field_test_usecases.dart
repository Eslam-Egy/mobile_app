import '../entities/field_test_entity.dart';
import '../repositories/field_test_repository.dart';

class SaveFieldTestUseCase {
  final FieldTestRepository repository;

  SaveFieldTestUseCase(this.repository);

  Future<int> call(FieldTestEntity test) async {
    return await repository.saveFieldTest(test);
  }
}

class GetFieldTestHistoryUseCase {
  final FieldTestRepository repository;

  GetFieldTestHistoryUseCase(this.repository);

  Future<List<FieldTestEntity>> call({int limit = 50}) async {
    return await repository.getHistory(limit: limit);
  }
}

class RunLabBenchmarkUseCase {
  final FieldTestRepository repository;

  RunLabBenchmarkUseCase(this.repository);

  Future<BenchmarkResultEntity> call({int sizeKb = 512}) async {
    return await repository.runLabBenchmark(sizeKb: sizeKb);
  }
}
