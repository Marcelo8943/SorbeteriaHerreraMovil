class OrderListItemModel {
  final int id;
  final String orderCode;
  final String customerName;
  final DateTime? registrationDate;
  final DateTime? estimatedDeliveryDate;
  final String orderStatusName;
  final double totalOrder;

  const OrderListItemModel({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.registrationDate,
    required this.estimatedDeliveryDate,
    required this.orderStatusName,
    required this.totalOrder,
  });

  factory OrderListItemModel.fromJson(Map<String, dynamic> json) {
    return OrderListItemModel(
      id: json['id'] as int,
      orderCode: json['orderCode'] as String,
      customerName: json['customerName'] as String,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String),
      estimatedDeliveryDate: json['estimatedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['estimatedDeliveryDate'] as String),
      orderStatusName: json['orderStatusName'] as String,
      totalOrder: (json['totalOrder'] as num).toDouble(),
    );
  }
}
