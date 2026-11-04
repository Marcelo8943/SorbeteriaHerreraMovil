import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/inventory_filter_option.dart';
import 'package:herrera_system/data/models/inventory_page_model.dart';
import 'package:herrera_system/data/models/inventory_product_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';

class InventoryRepository {
  InventoryRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<InventoryPageModel> getInventory({
    required int page,
    required int pageSize,
    String? search,
    int? lineId,
    int? flavorId,
    int? presentationId,
    bool? lowStock,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.inventory,
      query: {
        'page': '$page',
        'pageSize': '$pageSize',
        if (search != null && search.isNotEmpty) 'search': search,
        if (lineId != null) 'lineId': '$lineId',
        if (flavorId != null) 'flavorId': '$flavorId',
        if (presentationId != null) 'presentationId': '$presentationId',
        if (lowStock != null) 'lowStock': '$lowStock',
      },
    );
    final pageData = _dataMap(response);
    final productsJson = pageData['data'];

    if (productsJson is! List) {
      throw const ParsingException();
    }

    return InventoryPageModel(
      products: productsJson
          .whereType<Map<String, dynamic>>()
          .map(InventoryProductModel.fromJson)
          .toList(),
      currentPage: pageData['currentPage'] as int? ?? page,
      totalPages: pageData['totalPages'] as int? ?? 1,
      totalRecords: pageData['totalRecords'] as int? ?? 0,
    );
  }

  Future<InventoryStatsModel> getStats() async {
    final response = await _apiClient.get(
      ApiConstants.inventoryStats,
      query: const {'period': 'week', 'days': '15'},
    );
    return InventoryStatsModel.fromJson(_dataMap(response));
  }

  Future<List<InventoryFilterOption>> getLines() =>
      _getOptions(ApiConstants.lines, 'lineName');

  Future<List<InventoryFilterOption>> getFlavors() =>
      _getOptions(ApiConstants.flavors, 'flavorName');

  Future<List<InventoryFilterOption>> getPresentations() =>
      _getOptions(ApiConstants.presentations, 'presentationName');

  Future<List<InventoryFilterOption>> _getOptions(
    String path,
    String nameKey,
  ) async {
    final response = await _apiClient.get(
      path,
      query: const {'page': '1', 'pageSize': '50'},
    );
    final items = _dataMap(response)['data'];

    if (items is! List) {
      throw const ParsingException();
    }

    return items.whereType<Map<String, dynamic>>().map((item) {
      return InventoryFilterOption(
        id: item['id'] as int? ?? 0,
        name: item[nameKey] as String? ?? '',
      );
    }).where((item) => item.id > 0 && item.name.isNotEmpty).toList();
  }

  Map<String, dynamic> _dataMap(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return data;
  }
}
