import '../entities/test_sim_entity.dart';

abstract class SimManagerRepository {
  List<TestSimEntity> getSimCards();
  Future<void> addSimCard(TestSimEntity sim);
  Future<void> deleteSimCard(String id);
}
