import 'dart:convert';

import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/precio_general_model.dart';
import 'package:herrera_system/data/repository/token_repository.dart';

class PrecioRepository {
  final ApiClient _apiClient;
  final TokenRepository _tokenRepository;

  PrecioRepository(this._apiClient, this._tokenRepository);

  Future<List<PrecioGeneralModel>> obtenerPreciosGenerales({
    int? lineId,
  }) async {
    final response = await _apiClient.get(
      '/GeneralPrices/general',
      query: lineId == null ? null : {'lineId': '$lineId'},
    );
    final data = _data(response);
    if (data is! List) throw const ParsingException();

    return data.map((item) {
      if (item is Map<String, dynamic>) {
        return PrecioGeneralModel.fromJson(item);
      }
      if (item is Map) {
        return PrecioGeneralModel.fromJson(
          item.map((key, value) => MapEntry('$key', value)),
        );
      }
      throw const ParsingException();
    }).toList();
  }

  Future<void> actualizarPreciosGenerales({
    required int linePresentationId,
    required double retailPrice,
    required double wholesalePrice,
  }) async {
    final createdBy = await _obtenerIdUsuario();
    final validFrom = DateTime.now().toIso8601String();

    for (final precio in [
      (priceTypeId: 1, value: retailPrice),
      (priceTypeId: 2, value: wholesalePrice),
    ]) {
      final response = await _apiClient.put(
        '/GeneralPrices/general/$linePresentationId',
        body: {
          'priceTypeId': precio.priceTypeId,
          'price': precio.value,
          'validFrom': validFrom,
          'validTo': null,
          'createdBy': createdBy,
        },
      );
      _data(response);
    }
  }

  Future<int> _obtenerIdUsuario() async {
    final token = await _tokenRepository.getToken();
    if (token == null) throw const UnauthorizedException();

    try {
      final partes = token.token.split('.');
      if (partes.length != 3) throw const ParsingException();
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(partes[1])),
      );
      final claims = jsonDecode(payload);
      if (claims is! Map) throw const ParsingException();

      for (final key in [
        'UserId',
        'userId',
        'sub',
        'nameid',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier',
      ]) {
        final id = int.tryParse(claims[key]?.toString() ?? '');
        if (id != null && id > 0) return id;
      }
    } on AppException {
      rethrow;
    } catch (_) {
      throw const ParsingException('No se pudo leer el usuario de la sesión.');
    }

    throw const UnauthorizedException(
      'La sesión no contiene el identificador del usuario. Inicia sesión nuevamente.',
    );
  }

  dynamic _data(dynamic response) {
    if (response is! Map) throw const ParsingException();
    final envelope = response.map((key, value) => MapEntry('$key', value));
    if (envelope['success'] == false) {
      throw ServerException(
        envelope['message']?.toString() ?? 'No se pudieron cargar los precios.',
      );
    }
    return envelope['data'];
  }
}
