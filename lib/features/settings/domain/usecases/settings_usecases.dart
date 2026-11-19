import '../entities/server_config_entity.dart';
import '../repositories/settings_repository.dart';

class GetServerConfigUseCase {
  final SettingsRepository repository;

  GetServerConfigUseCase(this.repository);

  ServerConfigEntity call() => repository.getServerConfig();
}

class SaveServerConfigUseCase {
  final SettingsRepository repository;

  SaveServerConfigUseCase(this.repository);

  Future<void> call(ServerConfigEntity config) async {
    await repository.saveServerConfig(config);
  }
}

class PingServerUseCase {
  final SettingsRepository repository;

  PingServerUseCase(this.repository);

  Future<double?> call(String host, int port) async {
    return await repository.pingServer(host, port);
  }
}
