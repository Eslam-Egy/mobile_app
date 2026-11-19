import '../entities/node_status_entity.dart';

abstract class NodeMonitorRepository {
  Future<NodeStatusEntity> getNodeStatus();
  Future<double> checkLatency();
}
