import 'order_detail_item_model.dart';

class OrderDetailModel {
  final int id;
  final String orderCode;
  final int customerId;
  final String customerName;
  final int orderStatusId;
  final String orderStatusName;
  final DateTime? registrationDate;
  final DateTime? estimatedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final double totalOrder;
  final String createdByUserName;
  final List<OrderDetailItemModel> details;

  const OrderDetailModel({
    required this.id,
    required this.orderCode,
    required this.customerId,
    required this.customerName,
    required this.orderStatusId,
    required this.orderStatusName,
    required this.registrationDate,
    required this.estimatedDeliveryDate,
    required this.actualDeliveryDate,
    required this.totalOrder,
    required this.createdByUserName,
    required this.details,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final detailItems = json['details'];
    if (detailItems is! List) {
      throw const FormatException('Formato del detalle del pedido inválido.');
    }
    return OrderDetailModel(
      id: json['id'] as int,
      orderCode: json['orderCode'] as String,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String,
      orderStatusId: json['orderStatusId'] as int,
      orderStatusName: json['orderStatusName'] as String,
      registrationDate: _parseDate(json['registrationDate']),
      estimatedDeliveryDate: _parseDate(json['estimatedDeliveryDate']),
      actualDeliveryDate: _parseDate(json['actualDeliveryDate']),
      totalOrder: (json['totalOrder'] as num).toDouble(),
      createdByUserName: json['createdByUserName'] as String,
      details: detailItems.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de producto de pedido inválido.');
        }
        return OrderDetailItemModel.fromJson(item);
      }).toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) =>
      value == null ? null : DateTime.parse(value as String);
}
