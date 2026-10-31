import '../data/models/info_producto_item.dart';
import '../data/repository/info_producto_repository.dart';

class InfoProductoService {
  final InfoProductoRepository _repository;

  InfoProductoService(this._repository);

  Future<List<InfoProductoItem>> obtenerLineas() => _repository.obtenerLineas();

  Future<List<InfoProductoItem>> obtenerPresentaciones() =>
      _repository.obtenerPresentaciones();

  Future<void> crear({required bool esLinea, required String nombre}) => esLinea
      ? _repository.crearLinea(nombre)
      : _repository.crearPresentacion(nombre);

  Future<void> actualizar({
    required bool esLinea,
    required int id,
    required String nombre,
    required bool activo,
  }) => esLinea
      ? _repository.actualizarLinea(id: id, nombre: nombre, activo: activo)
      : _repository.actualizarPresentacion(
          id: id,
          nombre: nombre,
          activo: activo,
        );
}
