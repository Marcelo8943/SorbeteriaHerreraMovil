class InventoryMovementStatsModel {
  const InventoryMovementStatsModel({
    required this.movementsToday,
    required this.restocksToday,
    required this.transfersToday,
  });

  final int movementsToday;
  final int restocksToday;
  final int transfersToday;

  factory InventoryMovementStatsModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementStatsModel(
      movementsToday: json['movementsToday'] as int? ?? 0,
      restocksToday: json['restocksToday'] as int? ?? 0,
      transfersToday: json['transfersToday'] as int? ?? 0,
    );
  }
}
