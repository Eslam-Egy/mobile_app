import '../../domain/entities/test_sim_entity.dart';
import '../../domain/repositories/sim_manager_repository.dart';
import '../datasources/sim_local_datasource.dart';
import '../models/test_sim_model.dart';

class SimManagerRepositoryImpl implements SimManagerRepository {
  final SimLocalDataSource localDataSource;

  SimManagerRepositoryImpl({required this.localDataSource});

  @override
  List<TestSimEntity> getSimCards() {
    return localDataSource.getSimCards();
  }

  @override
  Future<void> addSimCard(TestSimEntity sim) async {
    final list = localDataSource.getSimCards();
    list.insert(0, TestSimModel.fromEntity(sim));
    await localDataSource.saveSimCards(list);
  }

  @override
  Future<void> deleteSimCard(String id) async {
    final list = localDataSource.getSimCards();
    list.removeWhere((s) => s.id == id);
    await localDataSource.saveSimCards(list);
  }
}
