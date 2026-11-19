import '../entities/node_status_entity.dart';
import '../repositories/node_monitor_repository.dart';

class GetNodeStatusUseCase {
  final NodeMonitorRepository repository;

  GetNodeStatusUseCase(this.repository);

  Future<NodeStatusEntity> call() async {
    return await repository.getNodeStatus();
  }
}
