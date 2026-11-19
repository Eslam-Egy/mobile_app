import '../entities/server_config_entity.dart';

abstract class SettingsRepository {
  ServerConfigEntity getServerConfig();
  Future<void> saveServerConfig(ServerConfigEntity config);
  Future<double?> pingServer(String host, int port);
}
