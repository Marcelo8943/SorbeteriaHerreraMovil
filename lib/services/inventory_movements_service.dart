import 'package:herrera_system/data/models/inventory_movement_detail_item_model.dart';
import 'package:herrera_system/data/models/inventory_movement_header_model.dart';
import 'package:herrera_system/data/models/inventory_movement_page_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';
import 'package:herrera_system/data/repository/inventory_movements_repository.dart';

class InventoryMovementsService {
  InventoryMovementsService(this._repository);

  final InventoryMovementsRepository _repository;

  Future<InventoryMovementPageModel> getMovements({
    required int page,
    required int pageSize,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return _repository.getMovements(
      page: page,
      pageSize: pageSize,
      search: search,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<InventoryMovementStatsModel> getStats() => _repository.getStats();

  Future<InventoryMovementHeaderModel> getMovementById(int id) {
    return _repository.getMovementById(id);
  }

  Future<List<InventoryMovementDetailItemModel>> getMovementDetails(int id) {
    return _repository.getMovementDetails(id);
  }
}
