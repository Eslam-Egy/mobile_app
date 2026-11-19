import '../../domain/entities/node_status_entity.dart';

class SystemTelemetryModel extends SystemTelemetryEntity {
  const SystemTelemetryModel({
    required super.cpuUsagePct,
    required super.ramUsagePct,
    required super.ramUsedMb,
    required super.ramTotalMb,
    required super.cpuCount,
  });

  factory SystemTelemetryModel.fromJson(Map<String, dynamic> json) {
    return SystemTelemetryModel(
      cpuUsagePct: (json['cpu_usage_pct'] as num?)?.toDouble() ?? 0.0,
      ramUsagePct: (json['ram_usage_pct'] as num?)?.toDouble() ?? 0.0,
      ramUsedMb: (json['ram_used_mb'] as num?)?.toDouble() ?? 0.0,
      ramTotalMb: (json['ram_total_mb'] as num?)?.toDouble() ?? 0.0,
      cpuCount: (json['cpu_count'] as num?)?.toInt() ?? 1,
    );
  }
}

class ServiceStatusModel extends ServiceStatusEntity {
  const ServiceStatusModel({
    required super.running,
    super.pid,
    required super.statusLabel,
    required super.details,
  });

  factory ServiceStatusModel.fromJson(Map<String, dynamic> json) {
    return ServiceStatusModel(
      running: json['running'] as bool? ?? false,
      pid: json['pid'] as int?,
      statusLabel: json['status_label'] as String? ?? 'Unknown',
      details: json['details'] as String? ?? '',
    );
  }
}

class SdrHardwareModel extends SdrHardwareEntity {
  const SdrHardwareModel({
    required super.model,
    required super.status,
    required super.safeMode,
    required super.details,
  });

  factory SdrHardwareModel.fromJson(Map<String, dynamic> json) {
    return SdrHardwareModel(
      model: json['model'] as String? ?? 'NI USRP-2901',
      status: json['status'] as String? ?? 'Unknown',
      safeMode: json['safe_mode'] as bool? ?? true,
      details: json['details'] as String? ?? '',
    );
  }
}

class NodeStatusModel extends NodeStatusEntity {
  const NodeStatusModel({
    required super.timestamp,
    required super.nodeType,
    required super.plmn,
    required super.system,
    required super.openbts,
    required super.asterisk,
    required super.sdr,
    required super.recentLogs,
  });

  factory NodeStatusModel.fromJson(Map<String, dynamic> json) {
    final services = json['services'] as Map<String, dynamic>? ?? {};
    return NodeStatusModel(
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      nodeType: json['node_type'] as String? ?? '3G / UMTS Node B',
      plmn: json['plmn'] as String? ?? '001/01',
      system: SystemTelemetryModel.fromJson(json['system'] as Map<String, dynamic>? ?? {}),
      openbts: ServiceStatusModel.fromJson(services['openbts_umts'] as Map<String, dynamic>? ?? {}),
      asterisk: ServiceStatusModel.fromJson(services['asterisk_pbx'] as Map<String, dynamic>? ?? {}),
      sdr: SdrHardwareModel.fromJson(services['sdr_hardware'] as Map<String, dynamic>? ?? {}),
      recentLogs: (json['recent_logs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
