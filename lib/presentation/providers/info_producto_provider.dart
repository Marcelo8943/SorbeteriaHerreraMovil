import 'package:flutter/foundation.dart';

import '../../data/models/info_producto_item.dart';
import '../../services/info_producto_service.dart';

class InfoProductoProvider extends ChangeNotifier {
  final InfoProductoService _service;

  InfoProductoProvider(this._service);

  List<InfoProductoItem> lineas = const [];
  List<InfoProductoItem> presentaciones = const [];
  bool cargando = true;
  bool guardando = false;
  String? error;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      final resultados = await Future.wait<List<InfoProductoItem>>([
        _service.obtenerLineas(),
        _service.obtenerPresentaciones(),
      ]);
      lineas = resultados[0];
      presentaciones = resultados[1];
    } catch (exception) {
      error = _mensajeError(exception);
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> crear({required bool esLinea, required String nombre}) async {
    guardando = true;
    notifyListeners();
    try {
      await _service.crear(esLinea: esLinea, nombre: nombre);
      await _recargarCatalogo();
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<void> actualizar({
    required bool esLinea,
    required int id,
    required String nombre,
    required bool activo,
  }) async {
    guardando = true;
    notifyListeners();
    try {
      await _service.actualizar(
        esLinea: esLinea,
        id: id,
        nombre: nombre,
        activo: activo,
      );
      await _recargarCatalogo();
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<void> _recargarCatalogo() async {
    try {
      final resultados = await Future.wait<List<InfoProductoItem>>([
        _service.obtenerLineas(),
        _service.obtenerPresentaciones(),
      ]);
      lineas = resultados[0];
      presentaciones = resultados[1];
      error = null;
    } catch (exception) {
      error = _mensajeError(exception);
    }
  }

  static String _mensajeError(Object exception) =>
      exception.toString().replaceFirst(RegExp(r'^[^:]+: '), '');
}
