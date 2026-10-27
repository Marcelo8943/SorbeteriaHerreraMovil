import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/data/repository/cliente_repository.dart';

class ClienteService {
  final ClienteRepository _repository;

  ClienteService(this._repository);

  Future<PaginaClientes> obtenerClientes({
    required int page,
    int pageSize = 10,
    String? search,
    int? departmentId,
    int? municipalityId,
  }) => _repository.obtenerClientes(
    page: page,
    pageSize: pageSize,
    search: search,
    departmentId: departmentId,
    municipalityId: municipalityId,
  );

  Future<ClienteEstadisticas> obtenerEstadisticas() =>
      _repository.obtenerEstadisticas();
  Future<ClienteModel> obtenerCliente(int id) => _repository.obtenerCliente(id);
  Future<List<DepartamentoCliente>> obtenerDepartamentos() =>
      _repository.obtenerDepartamentos();
  Future<List<MunicipioCliente>> obtenerMunicipios(int departmentId) =>
      _repository.obtenerMunicipios(departmentId);

  Future<ClienteModel> crearCliente({
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
  }) => _repository.crearCliente(
    municipalityId: municipalityId,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    pointOfSale: pointOfSale,
    posAddress: posAddress,
  );

  Future<void> actualizarCliente({
    required int id,
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
    required bool isActive,
  }) => _repository.actualizarCliente(
    id: id,
    municipalityId: municipalityId,
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    pointOfSale: pointOfSale,
    posAddress: posAddress,
    isActive: isActive,
  );

  Future<void> eliminarCliente(int id) => _repository.eliminarCliente(id);
}
