import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/server_config_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/server_config_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  final DioClient dioClient;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.dioClient,
  });

  @override
  ServerConfigEntity getServerConfig() {
    return localDataSource.getServerConfig();
  }

  @override
  Future<void> saveServerConfig(ServerConfigEntity config) async {
    final model = ServerConfigModel.fromEntity(config);
    await localDataSource.saveServerConfig(model);
    dioClient.updateBaseUrl(config.baseUrl);
  }

  @override
  Future<double?> pingServer(String host, int port) async {
    final tempDio = Dio(
      BaseOptions(
        baseUrl: 'http://$host:$port',
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    final stopwatch = Stopwatch()..start();
    try {
      final res = await tempDio.get(ApiConstants.pingEndpoint);
      stopwatch.stop();
      if (res.statusCode == 200) {
        return stopwatch.elapsedMicroseconds / 1000.0;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
