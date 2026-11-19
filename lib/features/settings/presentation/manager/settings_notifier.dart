import 'package:flutter/foundation.dart';
import '../../domain/entities/server_config_entity.dart';
import '../../domain/usecases/settings_usecases.dart';

class SettingsNotifier extends ChangeNotifier {
  final GetServerConfigUseCase getServerConfigUseCase;
  final SaveServerConfigUseCase saveServerConfigUseCase;
  final PingServerUseCase pingServerUseCase;

  late ServerConfigEntity _config;
  bool _isTesting = false;
  String? _testMessage;
  bool? _testSuccess;

  SettingsNotifier({
    required this.getServerConfigUseCase,
    required this.saveServerConfigUseCase,
    required this.pingServerUseCase,
  }) {
    _config = getServerConfigUseCase();
  }

  ServerConfigEntity get config => _config;
  bool get isTesting => _isTesting;
  String? get testMessage => _testMessage;
  bool? get testSuccess => _testSuccess;

  Future<void> saveConfig({required String host, required int port, required bool autoPoll}) async {
    _config = ServerConfigEntity(host: host.trim(), port: port, autoPoll: autoPoll);
    await saveServerConfigUseCase(_config);
    notifyListeners();
  }

  Future<void> testConnection(String host, int port) async {
    _isTesting = true;
    _testMessage = 'Pinging host laptop over Wi-Fi...';
    _testSuccess = null;
    notifyListeners();

    final latency = await pingServerUseCase(host.trim(), port);
    _isTesting = false;
    _testSuccess = latency != null;

    if (latency != null) {
      _testMessage = 'Connection successful! RTT Latency: ${latency.toStringAsFixed(1)} ms\nFastAPI backend is active on Ubuntu laptop.';
    } else {
      _testMessage = 'Cannot reach http://$host:$port\n• Verify phone is on same Wi-Fi router\n• Run "hostname -I" on Ubuntu laptop\n• Ensure "sudo ufw allow 8000/tcp" is allowed';
    }
    notifyListeners();
  }
}
