import 'restock_detail_batch_model.dart';

class RestockDetailModel {
  final int restockId;
  final String restockCode;
  final DateTime? restockDate;
  final String userName;
  final int batchCount;
  final int totalUnits;
  final double totalInvestment;
  final int differentProductsCount;
  final List<RestockDetailBatchModel> batches;

  const RestockDetailModel({
    required this.restockId,
    required this.restockCode,
    required this.restockDate,
    required this.userName,
    required this.batchCount,
    required this.totalUnits,
    required this.totalInvestment,
    required this.differentProductsCount,
    required this.batches,
  });

  factory RestockDetailModel.fromJson(Map<String, dynamic> json) {
    final batchItems = json['batches'];
    if (batchItems is! List) {
      throw const FormatException('Formato de lotes del reabastecimiento inválido.');
    }
    return RestockDetailModel(
      restockId: json['restockId'] as int,
      restockCode: json['restockCode'] as String,
      restockDate: json['restockDate'] == null
          ? null
          : DateTime.parse(json['restockDate'] as String),
      userName: json['userName'] as String,
      batchCount: json['batchCount'] as int,
      totalUnits: json['totalUnits'] as int,
      totalInvestment: (json['totalInvestment'] as num).toDouble(),
      differentProductsCount: json['differentProductsCount'] as int,
      batches: batchItems.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de lote inválido.');
        }
        return RestockDetailBatchModel.fromJson(item);
      }).toList(),
    );
  }
}
