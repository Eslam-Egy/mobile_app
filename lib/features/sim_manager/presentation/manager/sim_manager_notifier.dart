import 'package:flutter/foundation.dart';
import '../../domain/entities/test_sim_entity.dart';
import '../../domain/usecases/sim_manager_usecases.dart';

class SimManagerNotifier extends ChangeNotifier {
  final GetSimCardsUseCase getSimCardsUseCase;
  final AddSimCardUseCase addSimCardUseCase;
  final DeleteSimCardUseCase deleteSimCardUseCase;

  List<TestSimEntity> _simCards = [];

  SimManagerNotifier({
    required this.getSimCardsUseCase,
    required this.addSimCardUseCase,
    required this.deleteSimCardUseCase,
  });

  List<TestSimEntity> get simCards => _simCards;

  void loadSimCards() {
    _simCards = getSimCardsUseCase();
    notifyListeners();
  }

  Future<void> addSimCard(TestSimEntity sim) async {
    await addSimCardUseCase(sim);
    loadSimCards();
  }

  Future<void> deleteSimCard(String id) async {
    await deleteSimCardUseCase(id);
    loadSimCards();
  }
}
