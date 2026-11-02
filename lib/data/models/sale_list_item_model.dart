class SaleListItemModel {
  final int id;
  final String saleCode;
  final DateTime? saleDate;
  final String customerName;
  final int saleTypeId;
  final String saleTypeName;
  final int paymentTypeId;
  final String paymentTypeName;
  final double total;
  final String paymentStatus;

  const SaleListItemModel({
    required this.id,
    required this.saleCode,
    required this.saleDate,
    required this.customerName,
    required this.saleTypeId,
    required this.saleTypeName,
    required this.paymentTypeId,
    required this.paymentTypeName,
    required this.total,
    required this.paymentStatus,
  });

  factory SaleListItemModel.fromJson(Map<String, dynamic> json) {
    return SaleListItemModel(
      id: json['id'] as int,
      saleCode: json['saleCode'] as String,
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
      customerName: json['customerName'] as String,
      saleTypeId: json['saleTypeId'] as int,
      saleTypeName: json['saleTypeName'] as String,
      paymentTypeId: json['paymentTypeId'] as int,
      paymentTypeName: json['paymentTypeName'] as String,
      total: (json['total'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
    );
  }
}
