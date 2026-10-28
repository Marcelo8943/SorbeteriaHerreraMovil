class InventoryProductModel {
  const InventoryProductModel({
    required this.productId,
    required this.productName,
    required this.lineName,
    required this.presentationName,
    required this.flavorName,
    required this.displayStock,
    required this.warehouseStock,
    required this.reservedStock,
    required this.totalStock,
    required this.minimumStock,
    required this.lowStock,
  });

  final int productId;
  final String productName;
  final String lineName;
  final String presentationName;
  final String flavorName;
  final int displayStock;
  final int warehouseStock;
  final int reservedStock;
  final int totalStock;
  final int minimumStock;
  final bool lowStock;

  factory InventoryProductModel.fromJson(Map<String, dynamic> json) {
    return InventoryProductModel(
      productId: json['productId'] as int? ?? 0,
      productName: json['productName'] as String? ?? '',
      lineName: json['lineName'] as String? ?? '',
      presentationName: json['presentationName'] as String? ?? '',
      flavorName: json['flavorName'] as String? ?? '',
      displayStock: json['displayStock'] as int? ?? 0,
      warehouseStock: json['warehouseStock'] as int? ?? 0,
      reservedStock: json['reservedStock'] as int? ?? 0,
      totalStock: json['totalStock'] as int? ?? 0,
      minimumStock: json['minimumStock'] as int? ?? 0,
      lowStock: json['lowStock'] as bool? ?? false,
    );
  }
}
