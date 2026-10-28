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
}
