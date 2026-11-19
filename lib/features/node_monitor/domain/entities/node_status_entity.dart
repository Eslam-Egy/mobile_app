class SystemTelemetryEntity {
  final double cpuUsagePct;
  final double ramUsagePct;
  final double ramUsedMb;
  final double ramTotalMb;
  final int cpuCount;

  const SystemTelemetryEntity({
    required this.cpuUsagePct,
    required this.ramUsagePct,
    required this.ramUsedMb,
    required this.ramTotalMb,
    required this.cpuCount,
  });
}

class ServiceStatusEntity {
  final bool running;
  final int? pid;
  final String statusLabel;
  final String details;

  const ServiceStatusEntity({
    required this.running,
    this.pid,
    required this.statusLabel,
    required this.details,
  });
}

class SdrHardwareEntity {
  final String model;
  final String status;
  final bool safeMode;
  final String details;

  const SdrHardwareEntity({
    required this.model,
    required this.status,
    required this.safeMode,
    required this.details,
  });

  bool get isActiveInUse => status.contains('Active') || status.contains('In-Use');
  bool get isStandby => status.contains('Standby') || status.contains('Idle');
}

class NodeStatusEntity {
  final DateTime timestamp;
  final String nodeType;
  final String plmn;
  final SystemTelemetryEntity system;
  final ServiceStatusEntity openbts;
  final ServiceStatusEntity asterisk;
  final SdrHardwareEntity sdr;
  final List<String> recentLogs;

  const NodeStatusEntity({
    required this.timestamp,
    required this.nodeType,
    required this.plmn,
    required this.system,
    required this.openbts,
    required this.asterisk,
    required this.sdr,
    required this.recentLogs,
  });
}
