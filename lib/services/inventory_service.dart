import 'package:herrera_system/data/models/inventory_filter_option.dart';
import 'package:herrera_system/data/models/inventory_page_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';
import 'package:herrera_system/data/repository/inventory_repository.dart';

class InventoryService {
  InventoryService(this._repository);

  final InventoryRepository _repository;

  Future<InventoryPageModel> getInventory({
    required int page,
    required int pageSize,
    String? search,
    int? lineId,
    int? flavorId,
    int? presentationId,
    bool? lowStock,
  }) {
    return _repository.getInventory(
      page: page,
      pageSize: pageSize,
      search: search,
      lineId: lineId,
      flavorId: flavorId,
      presentationId: presentationId,
      lowStock: lowStock,
    );
  }

  Future<InventoryStatsModel> getStats() => _repository.getStats();

  Future<List<InventoryFilterOption>> getLines() => _repository.getLines();

  Future<List<InventoryFilterOption>> getFlavors() => _repository.getFlavors();

  Future<List<InventoryFilterOption>> getPresentations() =>
      _repository.getPresentations();
}
