class RestockListItemModel {
  final int restockId;
  final String restockCode;
  final DateTime? restockDate;
  final String userName;
  final int batchCount;
  final int totalUnits;
  final double totalInvestment;

  const RestockListItemModel({
    required this.restockId,
    required this.restockCode,
    required this.restockDate,
    required this.userName,
    required this.batchCount,
    required this.totalUnits,
    required this.totalInvestment,
  });

  factory RestockListItemModel.fromJson(Map<String, dynamic> json) {
    return RestockListItemModel(
      restockId: json['restockId'] as int,
      restockCode: json['restockCode'] as String,
      restockDate: json['restockDate'] == null
          ? null
          : DateTime.parse(json['restockDate'] as String),
      userName: json['userName'] as String,
      batchCount: json['batchCount'] as int,
      totalUnits: json['totalUnits'] as int,
      totalInvestment: (json['totalInvestment'] as num).toDouble(),
    );
  }
}
