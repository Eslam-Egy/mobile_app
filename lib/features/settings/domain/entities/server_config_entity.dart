class ServerConfigEntity {
  final String host;
  final int port;
  final bool autoPoll;

  const ServerConfigEntity({
    required this.host,
    required this.port,
    required this.autoPoll,
  });

  String get baseUrl => 'http://$host:$port';
}
