class InventoryStatsModel {
  const InventoryStatsModel({
    required this.totalProducts,
    required this.totalUnits,
    required this.lowStockProducts,
    required this.expiringLots,
    required this.inventoryValue,
    this.bestSellingFlavorName,
    this.bestSellingFlavorQuantity = 0,
  });

  final int totalProducts;
  final int totalUnits;
  final int lowStockProducts;
  final int expiringLots;
  final double inventoryValue;
  final String? bestSellingFlavorName;
  final int bestSellingFlavorQuantity;

  factory InventoryStatsModel.fromJson(Map<String, dynamic> json) {
    final bestSellingFlavor = json['bestSellingFlavor'];
    return InventoryStatsModel(
      totalProducts: json['totalProducts'] as int? ?? 0,
      totalUnits: json['totalUnits'] as int? ?? 0,
      lowStockProducts: json['lowStockProducts'] as int? ?? 0,
      expiringLots: json['expiringLots'] as int? ?? 0,
      inventoryValue: (json['inventoryValue'] as num?)?.toDouble() ?? 0,
      bestSellingFlavorName: bestSellingFlavor is Map<String, dynamic>
          ? bestSellingFlavor['flavorName']?.toString()
          : null,
      bestSellingFlavorQuantity: bestSellingFlavor is Map<String, dynamic>
          ? (bestSellingFlavor['quantitySold'] as int? ?? 0)
          : 0,
    );
  }
}
