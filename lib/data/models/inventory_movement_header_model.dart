class InventoryMovementHeaderModel {
  const InventoryMovementHeaderModel({
    required this.id,
    required this.movementTypeName,
    required this.movementDate,
    required this.notes,
    required this.createdByUserName,
    required this.saleId,
    required this.orderId,
  });

  final int id;
  final String movementTypeName;
  final DateTime? movementDate;
  final String? notes;
  final String? createdByUserName;
  final int? saleId;
  final int? orderId;

  factory InventoryMovementHeaderModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementHeaderModel(
      id: json['id'] as int? ?? 0,
      movementTypeName: json['movementTypeName'] as String? ?? '',
      movementDate: _parseDate(json['movementDate']),
      notes: json['notes'] as String?,
      createdByUserName: json['createdByUserName'] as String?,
      saleId: json['saleId'] as int?,
      orderId: json['orderId'] as int?,
    );
  }

  String get dateLabel {
    final date = movementDate;
    if (date == null) return 'Sin fecha';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/${date.year} · $hour:$minute';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String) return null;
    return DateTime.tryParse(value)?.toLocal();
  }
}
