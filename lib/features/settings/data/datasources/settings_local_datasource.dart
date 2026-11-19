import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/storage_constants.dart';
import '../models/server_config_model.dart';

abstract class SettingsLocalDataSource {
  ServerConfigModel getServerConfig();
  Future<void> saveServerConfig(ServerConfigModel config);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  ServerConfigModel getServerConfig() {
    final host = sharedPreferences.getString(StorageConstants.keyServerHost) ?? ApiConstants.defaultHost;
    final port = sharedPreferences.getInt(StorageConstants.keyServerPort) ?? ApiConstants.defaultPort;
    final autoPoll = sharedPreferences.getBool(StorageConstants.keyAutoPoll) ?? true;

    return ServerConfigModel(host: host, port: port, autoPoll: autoPoll);
  }

  @override
  Future<void> saveServerConfig(ServerConfigModel config) async {
    await sharedPreferences.setString(StorageConstants.keyServerHost, config.host);
    await sharedPreferences.setInt(StorageConstants.keyServerPort, config.port);
    await sharedPreferences.setBool(StorageConstants.keyAutoPoll, config.autoPoll);
  }
}
