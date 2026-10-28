class InventoryMovementStatsModel {
  const InventoryMovementStatsModel({
    required this.movementsToday,
    required this.restocksToday,
    required this.transfersToday,
    required this.positiveAdjustmentsToday,
    required this.negativeAdjustmentsToday,
  });

  final int movementsToday;
  final int restocksToday;
  final int transfersToday;
  final int positiveAdjustmentsToday;
  final int negativeAdjustmentsToday;

  int get adjustmentsToday =>
      positiveAdjustmentsToday + negativeAdjustmentsToday;

  factory InventoryMovementStatsModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementStatsModel(
      movementsToday: json['movementsToday'] as int? ?? 0,
      restocksToday: json['restocksToday'] as int? ?? 0,
      transfersToday: json['transfersToday'] as int? ?? 0,
      positiveAdjustmentsToday: json['positiveAdjustmentsToday'] as int? ?? 0,
      negativeAdjustmentsToday: json['negativeAdjustmentsToday'] as int? ?? 0,
    );
  }
}
