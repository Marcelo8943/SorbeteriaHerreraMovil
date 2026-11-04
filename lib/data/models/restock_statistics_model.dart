class RestockStatisticsModel {
  final int restocksThisMonth;
  final double totalInvestmentThisMonth;
  final int batchesCreatedThisMonth;

  const RestockStatisticsModel({
    required this.restocksThisMonth,
    required this.totalInvestmentThisMonth,
    required this.batchesCreatedThisMonth,
  });

  factory RestockStatisticsModel.fromJson(Map<String, dynamic> json) {
    return RestockStatisticsModel(
      restocksThisMonth: json['restocksThisMonth'] as int,
      totalInvestmentThisMonth: (json['totalInvestmentThisMonth'] as num)
          .toDouble(),
      batchesCreatedThisMonth: json['batchesCreatedThisMonth'] as int,
    );
  }
}
