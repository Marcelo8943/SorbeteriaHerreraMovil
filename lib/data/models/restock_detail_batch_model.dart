class RestockDetailBatchModel {
  final int batchId;
  final String? batchCode;
  final String productName;
  final String batchStatusName;
  final int initialQuantity;
  final double unitProductionCost;
  final double totalCost;
  final DateTime expirationDate;

  const RestockDetailBatchModel({
    required this.batchId,
    required this.batchCode,
    required this.productName,
    required this.batchStatusName,
    required this.initialQuantity,
    required this.unitProductionCost,
    required this.totalCost,
    required this.expirationDate,
  });

  factory RestockDetailBatchModel.fromJson(Map<String, dynamic> json) {
    return RestockDetailBatchModel(
      batchId: json['batchId'] as int,
      batchCode: json['batchCode'] as String?,
      productName: json['productName'] as String,
      batchStatusName: json['batchStatusName'] as String,
      initialQuantity: json['initialQuantity'] as int,
      unitProductionCost: (json['unitProductionCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      expirationDate: DateTime.parse(json['expirationDate'] as String),
    );
  }
}
