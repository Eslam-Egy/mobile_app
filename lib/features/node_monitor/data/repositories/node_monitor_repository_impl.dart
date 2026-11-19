import '../../domain/entities/node_status_entity.dart';
import '../../domain/repositories/node_monitor_repository.dart';
import '../datasources/node_monitor_remote_datasource.dart';

class NodeMonitorRepositoryImpl implements NodeMonitorRepository {
  final NodeMonitorRemoteDataSource remoteDataSource;

  NodeMonitorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NodeStatusEntity> getNodeStatus() async {
    return await remoteDataSource.fetchNodeStatus();
  }

  @override
  Future<double> checkLatency() async {
    return await remoteDataSource.measurePingLatency();
  }
}
