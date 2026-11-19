import '../../domain/entities/field_test_entity.dart';

class FieldTestModel extends FieldTestEntity {
  const FieldTestModel({
    super.id,
    required super.timestamp,
    required super.testLabel,
    super.imsi,
    super.extension,
    required super.plmnDetected,
    required super.rscpDbm,
    required super.attachStatus,
    super.latencyMs,
    super.throughputKbps,
    super.notes,
  });

  factory FieldTestModel.fromJson(Map<String, dynamic> json) {
    return FieldTestModel(
      id: json['id'] as int?,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      testLabel: json['test_label'] as String? ?? 'Lab Test',
      imsi: json['imsi'] as String?,
      extension: json['extension'] as String?,
      plmnDetected: json['plmn_detected'] == 1 || json['plmn_detected'] == true,
      rscpDbm: (json['rscp_dbm'] as num?)?.toDouble() ?? -95.0,
      attachStatus: json['attach_status'] as String? ?? 'Searching',
      latencyMs: (json['latency_ms'] as num?)?.toDouble(),
      throughputKbps: (json['throughput_kbps'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  factory FieldTestModel.fromEntity(FieldTestEntity entity) {
    return FieldTestModel(
      id: entity.id,
      timestamp: entity.timestamp,
      testLabel: entity.testLabel,
      imsi: entity.imsi,
      extension: entity.extension,
      plmnDetected: entity.plmnDetected,
      rscpDbm: entity.rscpDbm,
      attachStatus: entity.attachStatus,
      latencyMs: entity.latencyMs,
      throughputKbps: entity.throughputKbps,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'timestamp': timestamp.toIso8601String(),
      'test_label': testLabel,
      'imsi': imsi,
      'extension': extension,
      'plmn_detected': plmnDetected,
      'rscp_dbm': rscpDbm,
      'attach_status': attachStatus,
      'latency_ms': latencyMs,
      'throughput_kbps': throughputKbps,
      'notes': notes,
    };
  }
}
