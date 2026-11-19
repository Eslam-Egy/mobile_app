class TestSimEntity {
  final String id;
  final String cardName;
  final String imsi;
  final String extension;
  final String cardType;
  final String notes;
  final DateTime createdAt;

  const TestSimEntity({
    required this.id,
    required this.cardName,
    required this.imsi,
    required this.extension,
    required this.cardType,
    required this.notes,
    required this.createdAt,
  });
}
