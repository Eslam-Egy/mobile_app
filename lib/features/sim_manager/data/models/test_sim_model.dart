import 'dart:convert';
import '../../domain/entities/test_sim_entity.dart';

class TestSimModel extends TestSimEntity {
  const TestSimModel({
    required super.id,
    required super.cardName,
    required super.imsi,
    required super.extension,
    required super.cardType,
    required super.notes,
    required super.createdAt,
  });

  factory TestSimModel.fromJson(Map<String, dynamic> json) {
    return TestSimModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      cardName: json['card_name'] as String? ?? 'Test SIM',
      imsi: json['imsi'] as String? ?? '001010000000001',
      extension: json['extension'] as String? ?? '1001',
      cardType: json['card_type'] as String? ?? 'Programmable USIM',
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  factory TestSimModel.fromEntity(TestSimEntity entity) {
    return TestSimModel(
      id: entity.id,
      cardName: entity.cardName,
      imsi: entity.imsi,
      extension: entity.extension,
      cardType: entity.cardType,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_name': cardName,
      'imsi': imsi,
      'extension': extension,
      'card_type': cardType,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String toQrString() {
    final Map<String, dynamic> qrData = {
      'project': '3G_UMTS_LAB',
      'label': cardName,
      'imsi': imsi,
      'ext': extension,
      'type': cardType,
      'notes': notes,
      'security': 'NON_SENSITIVE_METADATA_ONLY'
    };
    return jsonEncode(qrData);
  }

  static TestSimModel? fromQrString(String rawData) {
    try {
      final decoded = jsonDecode(rawData);
      if (decoded is! Map<String, dynamic>) return null;

      // STRICT SECURITY CHECK
      if (decoded.containsKey('ki') || decoded.containsKey('opc') || decoded.containsKey('Ki')) {
        throw const FormatException('Sensitive cryptographic keys (Ki/OPc) are strictly forbidden.');
      }

      return TestSimModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardName: decoded['label'] as String? ?? decoded['card_name'] as String? ?? 'Scanned SIM',
        imsi: decoded['imsi'] as String? ?? '001010000000001',
        extension: decoded['ext'] as String? ?? decoded['extension'] as String? ?? '1001',
        cardType: decoded['type'] as String? ?? decoded['card_type'] as String? ?? 'Programmable USIM',
        notes: decoded['notes'] as String? ?? 'Scanned via QR Code in Lab',
        createdAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
