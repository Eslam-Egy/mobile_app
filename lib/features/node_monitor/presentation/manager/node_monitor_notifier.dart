import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/node_status_entity.dart';
import '../../domain/usecases/get_node_status_usecase.dart';

class NodeMonitorNotifier extends ChangeNotifier {
  final GetNodeStatusUseCase getNodeStatusUseCase;

  bool _isLoading = false;
  bool _isConnected = false;
  NodeStatusEntity? _status;
  String? _errorMessage;
  double? _latencyMs;
  Timer? _pollTimer;

  NodeMonitorNotifier({required this.getNodeStatusUseCase});

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  NodeStatusEntity? get status => _status;
  String? get errorMessage => _errorMessage;
  double? get latencyMs => _latencyMs;

  Future<void> fetchStatus({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await getNodeStatusUseCase();
      stopwatch.stop();

      _status = result;
      _isConnected = true;
      _latencyMs = stopwatch.elapsedMicroseconds / 1000.0;
      _errorMessage = null;
    } catch (e) {
      stopwatch.stop();
      _isConnected = false;
      _latencyMs = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPolling({Duration interval = const Duration(seconds: 5)}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(interval, (_) => fetchStatus(silent: true));
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
