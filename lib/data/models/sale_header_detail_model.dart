import 'sale_customer_info_model.dart';

class SaleHeaderDetailModel {
  final int id;
  final String saleCode;
  final DateTime? saleDate;
  final String? orderCode;
  final SaleCustomerInfoModel customer;
  final double total;
  final String paymentStatusName;
  final double? pendingBalance;
  final String? createdByUserName;
  final int paymentTypeId;
  final String paymentTypeName;
  final int saleTypeId;
  final String saleTypeName;

  const SaleHeaderDetailModel({
    required this.id,
    required this.saleCode,
    required this.saleDate,
    this.orderCode,
    required this.customer,
    required this.total,
    required this.paymentStatusName,
    this.pendingBalance,
    this.createdByUserName,
    required this.paymentTypeId,
    required this.paymentTypeName,
    required this.saleTypeId,
    required this.saleTypeName,
  });

  factory SaleHeaderDetailModel.fromJson(Map<String, dynamic> json) {
    final customerJson = json['customer'];
    if (customerJson is! Map<String, dynamic>) {
      throw const FormatException('Formato del cliente de la venta inválido.');
    }
    return SaleHeaderDetailModel(
      id: json['id'] as int,
      saleCode: json['saleCode'] as String,
      saleDate: json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
      orderCode: json['orderCode'] as String?,
      customer: SaleCustomerInfoModel.fromJson(customerJson),
      total: (json['total'] as num).toDouble(),
      paymentStatusName: json['paymentStatusName'] as String,
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble(),
      createdByUserName: json['createdByUserName'] as String?,
      paymentTypeId: json['paymentTypeId'] as int,
      paymentTypeName: json['paymentTypeName'] as String,
      saleTypeId: json['saleTypeId'] as int,
      saleTypeName: json['saleTypeName'] as String,
    );
  }
}
