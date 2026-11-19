import '../../domain/entities/server_config_entity.dart';

class ServerConfigModel extends ServerConfigEntity {
  const ServerConfigModel({
    required super.host,
    required super.port,
    required super.autoPoll,
  });

  factory ServerConfigModel.fromEntity(ServerConfigEntity entity) {
    return ServerConfigModel(
      host: entity.host,
      port: entity.port,
      autoPoll: entity.autoPoll,
    );
  }
}
