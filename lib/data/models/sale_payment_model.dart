class SalePaymentModel {
  final int id;
  final double amount;
  final String paymentMethodName;
  final DateTime? paymentDate;
  final String? transactionReference;
  final String? registeredByUserName;

  const SalePaymentModel({
    required this.id,
    required this.amount,
    required this.paymentMethodName,
    required this.paymentDate,
    this.transactionReference,
    this.registeredByUserName,
  });

  factory SalePaymentModel.fromJson(Map<String, dynamic> json) {
    return SalePaymentModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      paymentMethodName: json['paymentMethodName'] as String,
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      transactionReference: json['transactionReference'] as String?,
      registeredByUserName: json['registeredByUserName'] as String?,
    );
  }
}
