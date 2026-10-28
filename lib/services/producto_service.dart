import 'package:herrera_system/data/models/producto_catalogo_model.dart';
import 'package:herrera_system/data/repository/producto_repository.dart';

class ProductoService {
  final ProductoRepository _repository;

  ProductoService(this._repository);

  Future<PaginaProductos> obtenerCatalogo({
    required int page,
    int pageSize = 10,
    String? search,
    int? lineId,
    int? presentationId,
    int? flavorId,
    bool? active,
  }) => _repository.obtenerCatalogo(
    page: page,
    pageSize: pageSize,
    search: search,
    lineId: lineId,
    presentationId: presentationId,
    flavorId: flavorId,
    active: active,
  );

  Future<ProductoEstadisticasModel> obtenerEstadisticas() =>
      _repository.obtenerEstadisticas();

  Future<List<OpcionCatalogoProducto>> obtenerLineas() =>
      _repository.obtenerLineas();

  Future<List<OpcionCatalogoProducto>> obtenerSabores() =>
      _repository.obtenerSabores();

  Future<List<OpcionCatalogoProducto>> obtenerPresentaciones() =>
      _repository.obtenerPresentaciones();
}
