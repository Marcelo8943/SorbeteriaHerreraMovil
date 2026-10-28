import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/producto_catalogo_model.dart';

class ProductoRepository {
  final ApiClient _apiClient;

  ProductoRepository(this._apiClient);

  Future<PaginaProductos> obtenerCatalogo({
    required int page,
    int pageSize = 10,
    String? search,
    int? lineId,
    int? presentationId,
    int? flavorId,
    bool? active,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (lineId != null) 'lineId': '$lineId',
      if (presentationId != null) 'presentationId': '$presentationId',
      if (flavorId != null) 'flavorId': '$flavorId',
      if (active != null) 'active': '$active',
    };
    final data = _data(await _apiClient.get('/Products/catalog', query: query));
    return PaginaProductos.fromJson(_map(data));
  }

  Future<ProductoEstadisticasModel> obtenerEstadisticas() async =>
      ProductoEstadisticasModel.fromJson(
        _map(_data(await _apiClient.get('/Products/stats'))),
      );

  dynamic _data(dynamic response) {
    final envelope = _map(response);
    if (envelope['success'] == false) {
      throw ServerException(
        envelope['message']?.toString() ?? 'No se pudo completar la solicitud.',
      );
    }
    return envelope['data'];
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((key, value) => MapEntry('$key', value));
    throw const ParsingException();
  }
}
