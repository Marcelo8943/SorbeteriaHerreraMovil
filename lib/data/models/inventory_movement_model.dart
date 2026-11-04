class InventoryMovementModel {
  const InventoryMovementModel({
    required this.id,
    required this.movementTypeName,
    required this.movementDate,
    required this.createdByUserName,
    required this.productNames,
    required this.totalQuantity,
    required this.sourceLocationNames,
    required this.destinationLocationNames,
    required this.notes,
  });

  final int id;
  final String movementTypeName;
  final DateTime? movementDate;
  final String? createdByUserName;
  final List<String> productNames;
  final int totalQuantity;
  final List<String> sourceLocationNames;
  final List<String> destinationLocationNames;
  final String? notes;

  factory InventoryMovementModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementModel(
      id: json['id'] as int? ?? 0,
      movementTypeName: json['movementTypeName'] as String? ?? '',
      movementDate: _parseDate(json['movementDate']),
      createdByUserName: json['createdByUserName'] as String?,
      productNames: _stringList(json['productNames']),
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      sourceLocationNames: _stringList(json['sourceLocationNames']),
      destinationLocationNames: _stringList(json['destinationLocationNames']),
      notes: json['notes'] as String?,
    );
  }

  String get productLabel => productNames.isEmpty
      ? 'Sin productos asociados'
      : productNames.join(', ');

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

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }
}
