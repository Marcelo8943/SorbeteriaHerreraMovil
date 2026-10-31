class PrecioGeneralModel {
  final int linePresentationId;
  final String lineName;
  final String presentationName;
  final double? retailPrice;
  final double? wholesalePrice;
  final int productsCount;

  const PrecioGeneralModel({
    required this.linePresentationId,
    required this.lineName,
    required this.presentationName,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.productsCount,
  });

  factory PrecioGeneralModel.fromJson(Map<String, dynamic> json) =>
      PrecioGeneralModel(
        linePresentationId: _toInt(json['linePresentationId']),
        lineName: json['lineName']?.toString() ?? '',
        presentationName: json['presentationName']?.toString() ?? '',
        retailPrice: _toDouble(json['retailPrice']),
        wholesalePrice: _toDouble(json['wholesalePrice']),
        productsCount: _toInt(json['productsCount']),
      );

  static int _toInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
