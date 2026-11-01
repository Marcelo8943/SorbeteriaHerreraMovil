class SaleDetailItemModel {
  final int id;
  final int productId;
  final String productName;
  final String batchCode;
  final int quantity;
  final double unitPrice;
  final double lineSubtotal;

  const SaleDetailItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.batchCode,
    required this.quantity,
    required this.unitPrice,
    required this.lineSubtotal,
  });

  factory SaleDetailItemModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailItemModel(
      id: json['id'] as int,
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      batchCode: json['batchCode'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      lineSubtotal: (json['lineSubtotal'] as num).toDouble(),
    );
  }
}
