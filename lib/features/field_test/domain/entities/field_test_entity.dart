class FieldTestEntity {
  final int? id;
  final DateTime timestamp;
  final String testLabel;
  final String? imsi;
  final String? extension;
  final bool plmnDetected;
  final double rscpDbm;
  final String attachStatus; // 'Attached', 'Rejected', 'Searching'
  final double? latencyMs;
  final double? throughputKbps;
  final String? notes;

  const FieldTestEntity({
    this.id,
    required this.timestamp,
    required this.testLabel,
    this.imsi,
    this.extension,
    required this.plmnDetected,
    required this.rscpDbm,
    required this.attachStatus,
    this.latencyMs,
    this.throughputKbps,
    this.notes,
  });
}

class BenchmarkResultEntity {
  final double latencyMs;
  final double throughputKbps;

  const BenchmarkResultEntity({
    required this.latencyMs,
    required this.throughputKbps,
  });
}
