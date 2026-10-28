import 'inventory_movement_model.dart';

class InventoryMovementPageModel {
  const InventoryMovementPageModel({
    required this.movements,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
  });

  final List<InventoryMovementModel> movements;
  final int currentPage;
  final int totalPages;
  final int totalRecords;
}
