import '../entities/test_sim_entity.dart';
import '../repositories/sim_manager_repository.dart';

class GetSimCardsUseCase {
  final SimManagerRepository repository;

  GetSimCardsUseCase(this.repository);

  List<TestSimEntity> call() {
    return repository.getSimCards();
  }
}

class AddSimCardUseCase {
  final SimManagerRepository repository;

  AddSimCardUseCase(this.repository);

  Future<void> call(TestSimEntity sim) async {
    await repository.addSimCard(sim);
  }
}

class DeleteSimCardUseCase {
  final SimManagerRepository repository;

  DeleteSimCardUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteSimCard(id);
  }
}
