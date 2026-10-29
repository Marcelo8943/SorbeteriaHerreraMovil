import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/inventory_movement_detail_item_model.dart';
import 'package:herrera_system/data/models/inventory_movement_header_model.dart';
import 'package:herrera_system/data/models/inventory_movement_model.dart';
import 'package:herrera_system/data/models/inventory_movement_page_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';

class InventoryMovementsRepository {
  InventoryMovementsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<InventoryMovementPageModel> getMovements({
    required int page,
    required int pageSize,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.inventoryMovements,
      query: {
        'page': '$page',
        'pageSize': '$pageSize',
        if (search != null && search.isNotEmpty) 'search': search,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      },
    );
    final pageData = _dataMap(response);
    final movementsJson = pageData['data'];

    if (movementsJson is! List) {
      throw const ParsingException();
    }

    return InventoryMovementPageModel(
      movements: movementsJson
          .whereType<Map<String, dynamic>>()
          .map(InventoryMovementModel.fromJson)
          .toList(),
      currentPage: pageData['currentPage'] as int? ?? page,
      totalPages: pageData['totalPages'] as int? ?? 1,
      totalRecords: pageData['totalRecords'] as int? ?? 0,
    );
  }

  Future<InventoryMovementStatsModel> getStats() async {
    final response = await _apiClient.get(ApiConstants.inventoryMovementStats);
    return InventoryMovementStatsModel.fromJson(_dataMap(response));
  }

  Future<InventoryMovementHeaderModel> getMovementById(int id) async {
    final response = await _apiClient.get(
      '${ApiConstants.inventoryMovements}/$id',
    );
    return InventoryMovementHeaderModel.fromJson(_dataMap(response));
  }

  Future<List<InventoryMovementDetailItemModel>> getMovementDetails(
    int id,
  ) async {
    final response = await _apiClient.get(
      '${ApiConstants.inventoryMovements}/$id/details',
    );
    final data = _data(response);

    if (data is! List) {
      throw const ParsingException();
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(InventoryMovementDetailItemModel.fromJson)
        .toList();
  }

  Map<String, dynamic> _dataMap(dynamic response) {
    final data = _data(response);
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return data;
  }

  dynamic _data(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return response['data'];
  }
}
