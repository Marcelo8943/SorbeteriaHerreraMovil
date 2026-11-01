import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/data/models/dashboard_stats_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';
import 'package:herrera_system/data/models/producto_catalogo_model.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository(this._apiClient);

  Future<DashboardStatsModel> getStats() async {
    final responses = await Future.wait([
      _apiClient.get(ApiConstants.productStats),
      _apiClient.get(ApiConstants.customerStats),
      _apiClient.get(
        ApiConstants.inventoryStats,
        query: const {'period': 'week', 'days': '15'},
      ),
      _apiClient.get(ApiConstants.salesStats),
      _apiClient.get(ApiConstants.inventoryMovementStats),
    ]);

    return DashboardStatsModel(
      products: ProductoEstadisticasModel.fromJson(_dataMap(responses[0])),
      customers: ClienteEstadisticas.fromJson(_dataMap(responses[1])),
      inventory: InventoryStatsModel.fromJson(_dataMap(responses[2])),
      sales: SalesStatsModel.fromJson(_dataMap(responses[3])),
      movements: InventoryMovementStatsModel.fromJson(
        _dataMap(responses[4]),
      ),
    );
  }

  Map<String, dynamic> _dataMap(dynamic response) {
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudieron cargar las estadísticas.',
      );
    }
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    return data;
  }
}
