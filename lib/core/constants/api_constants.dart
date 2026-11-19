class ApiConstants {
  static const String defaultHost = '192.168.1.10';
  static const int defaultPort = 8000;

  static const String statusEndpoint = '/api/status';
  static const String pingEndpoint = '/api/ping';
  static const String speedtestEndpoint = '/api/speedtest';
  static const String telemetryEndpoint = '/api/telemetry';
  static const String telemetryExportEndpoint = '/api/telemetry/export';
  static const String logEventEndpoint = '/api/log_event';

  static const Duration connectTimeout = Duration(seconds: 4);
  static const Duration receiveTimeout = Duration(seconds: 5);
}
