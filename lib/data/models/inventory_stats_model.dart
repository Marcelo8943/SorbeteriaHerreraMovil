class InventoryStatsModel {
  const InventoryStatsModel({
    required this.totalProducts,
    required this.totalUnits,
    required this.lowStockProducts,
    required this.expiringLots,
    required this.inventoryValue,
  });

  final int totalProducts;
  final int totalUnits;
  final int lowStockProducts;
  final int expiringLots;
  final double inventoryValue;

  factory InventoryStatsModel.fromJson(Map<String, dynamic> json) {
    return InventoryStatsModel(
      totalProducts: json['totalProducts'] as int? ?? 0,
      totalUnits: json['totalUnits'] as int? ?? 0,
      lowStockProducts: json['lowStockProducts'] as int? ?? 0,
      expiringLots: json['expiringLots'] as int? ?? 0,
      inventoryValue: (json['inventoryValue'] as num?)?.toDouble() ?? 0,
    );
  }
}
