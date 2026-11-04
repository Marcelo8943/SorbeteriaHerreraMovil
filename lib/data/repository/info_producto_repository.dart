import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/network/api_client.dart';

import '../models/info_producto_item.dart';

class InfoProductoRepository {
  final ApiClient _apiClient;

  InfoProductoRepository(this._apiClient);

  Future<List<InfoProductoItem>> obtenerLineas() =>
      _obtener(ApiConstants.lines, 'lineName');

  Future<List<InfoProductoItem>> obtenerPresentaciones() =>
      _obtener(ApiConstants.presentations, 'presentationName');

  Future<void> crearLinea(String nombre) async {
    await _apiClient.post(
      ApiConstants.lines,
      body: {'lineName': nombre, 'isActive': true},
    );
  }

  Future<void> crearPresentacion(String nombre) async {
    await _apiClient.post(
      ApiConstants.presentations,
      body: {'presentationName': nombre, 'isActive': true},
    );
  }

  Future<void> actualizarLinea({
    required int id,
    required String nombre,
    required bool activo,
  }) async {
    await _apiClient.put(
      '${ApiConstants.lines}/$id',
      body: {'lineName': nombre, 'isActive': activo},
    );
  }

  Future<void> actualizarPresentacion({
    required int id,
    required String nombre,
    required bool activo,
  }) async {
    await _apiClient.put(
      '${ApiConstants.presentations}/$id',
      body: {'presentationName': nombre, 'isActive': activo},
    );
  }

  Future<List<InfoProductoItem>> _obtener(String path, String nombreKey) async {
    final response = _asMap(
      await _apiClient.get(path, query: const {'page': '1', 'pageSize': '100'}),
    );
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudo cargar el catálogo.',
      );
    }

    final data = _asMap(response['data']);
    final items = data['data'];
    if (items is! List) throw const ParsingException();
    return items
        .map(_asMap)
        .map((item) => InfoProductoItem.fromJson(item, nombreKey: nombreKey))
        .toList();
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((key, value) => MapEntry('$key', value));
    throw const ParsingException();
  }
}
