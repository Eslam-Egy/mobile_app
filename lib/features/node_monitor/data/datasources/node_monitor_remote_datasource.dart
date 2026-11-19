import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/node_status_model.dart';

abstract class NodeMonitorRemoteDataSource {
  Future<NodeStatusModel> fetchNodeStatus();
  Future<double> measurePingLatency();
}

class NodeMonitorRemoteDataSourceImpl implements NodeMonitorRemoteDataSource {
  final DioClient dioClient;

  NodeMonitorRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NodeStatusModel> fetchNodeStatus() async {
    final response = await dioClient.get(ApiConstants.statusEndpoint);
    if (response.statusCode == 200 && response.data != null) {
      return NodeStatusModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException(message: 'Failed to fetch Node B status', statusCode: response.statusCode);
    }
  }

  @override
  Future<double> measurePingLatency() async {
    final stopwatch = Stopwatch()..start();
    final response = await dioClient.get(ApiConstants.pingEndpoint);
    stopwatch.stop();

    if (response.statusCode == 200) {
      return stopwatch.elapsedMicroseconds / 1000.0;
    } else {
      throw ServerException(message: 'Ping failed', statusCode: response.statusCode);
    }
  }
}
