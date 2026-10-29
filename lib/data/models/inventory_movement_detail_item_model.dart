class InventoryMovementDetailItemModel {
  const InventoryMovementDetailItemModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.sourceLocationName,
    required this.destinationLocationName,
    required this.quantity,
    required this.unitCost,
    required this.createdByUserName,
    required this.createdAt,
  });

  final int id;
  final int batchId;
  final String? batchCode;
  final String? sourceLocationName;
  final String? destinationLocationName;
  final int quantity;
  final double unitCost;
  final String? createdByUserName;
  final DateTime? createdAt;

  factory InventoryMovementDetailItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementDetailItemModel(
      id: json['id'] as int? ?? 0,
      batchId: json['batchId'] as int? ?? 0,
      batchCode: json['batchCode'] as String?,
      sourceLocationName: json['sourceLocationName'] as String?,
      destinationLocationName: json['destinationLocationName'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0,
      createdByUserName: json['createdByUserName'] as String?,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  String get locationLabel {
    final source = sourceLocationName?.trim() ?? '';
    final destination = destinationLocationName?.trim() ?? '';

    if (source.isNotEmpty && destination.isNotEmpty) {
      return '$source → $destination';
    }

    if (source.isNotEmpty) return source;
    if (destination.isNotEmpty) return destination;
    return 'Sin ubicación registrada';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String) return null;
    return DateTime.tryParse(value)?.toLocal();
  }
}
