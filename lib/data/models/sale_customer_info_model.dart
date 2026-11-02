class SaleCustomerInfoModel {
  final int id;
  final String fullName;
  final String? departmentName;
  final String? municipalityName;
  final String? pointOfSale;

  const SaleCustomerInfoModel({
    required this.id,
    required this.fullName,
    this.departmentName,
    this.municipalityName,
    this.pointOfSale,
  });

  factory SaleCustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return SaleCustomerInfoModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      departmentName: json['departmentName'] as String?,
      municipalityName: json['municipalityName'] as String?,
      pointOfSale: json['pointOfSale'] as String?,
    );
  }
}
