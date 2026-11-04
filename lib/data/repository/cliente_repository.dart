import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/cliente_model.dart';

class ClienteRepository {
  final ApiClient _apiClient;

  ClienteRepository(this._apiClient);

  Future<PaginaClientes> obtenerClientes({
    required int page,
    int pageSize = 10,
    String? search,
    int? departmentId,
    int? municipalityId,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (departmentId != null) 'departmentId': '$departmentId',
      if (municipalityId != null) 'municipalityId': '$municipalityId',
    };
    final data = _data(await _apiClient.get('/Customers', query: query));
    return PaginaClientes.fromJson(_map(data));
  }

  Future<ClienteEstadisticas> obtenerEstadisticas() async =>
      ClienteEstadisticas.fromJson(
        _map(_data(await _apiClient.get('/Customers/stats'))),
      );

  Future<ClienteModel> obtenerCliente(int id) async => ClienteModel.fromJson(
    _map(_data(await _apiClient.get('/Customers/$id'))),
  );

  Future<List<DepartamentoCliente>> obtenerDepartamentos() async =>
      _list(_data(await _apiClient.get('/Departments')))
          .map(DepartamentoCliente.fromJson)
          .toList();

  Future<List<MunicipioCliente>> obtenerMunicipios(int departmentId) async =>
      _list(
        _data(
          await _apiClient.get('/Municipalities/by-department/$departmentId'),
        ),
      ).map(MunicipioCliente.fromJson).toList();

  Future<ClienteModel> crearCliente({
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
  }) async {
    final data = _data(
      await _apiClient.post(
        '/Customers',
        body: {
          'municipalityId': municipalityId,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'pointOfSale': pointOfSale,
          'posaddress': posAddress,
        },
      ),
    );
    return ClienteModel.fromJson(_map(data));
  }

  Future<void> actualizarCliente({
    required int id,
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
    required bool isActive,
  }) async {
    await _apiClient.put(
      '/Customers/$id',
      body: {
        'municipalityId': municipalityId,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'pointOfSale': pointOfSale,
        'posaddress': posAddress,
        'isActive': isActive,
      },
    );
  }

  Future<void> eliminarCliente(int id) async =>
      _apiClient.delete('/Customers/$id');

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

  List<Map<String, dynamic>> _list(dynamic value) {
    if (value is! List) throw const ParsingException();
    return value.map(_map).toList();
  }
}
