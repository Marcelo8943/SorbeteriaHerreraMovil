class OrderDetailItemModel {
  final int id;
  final int productId;
  final String productName;
  final int quantityRequested;
  final int productPriceId;
  final double appliedPrice;
  final int? batchId;
  final String? batchCode;
  final double lineSubtotal;

  const OrderDetailItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantityRequested,
    required this.productPriceId,
    required this.appliedPrice,
    required this.batchId,
    required this.batchCode,
    required this.lineSubtotal,
  });

  factory OrderDetailItemModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailItemModel(
      id: json['id'] as int,
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      quantityRequested: json['quantityRequested'] as int,
      productPriceId: json['productPriceId'] as int,
      appliedPrice: (json['appliedPrice'] as num).toDouble(),
      batchId: json['batchId'] as int?,
      batchCode: json['batchCode'] as String?,
      lineSubtotal: (json['lineSubtotal'] as num).toDouble(),
    );
  }
}
