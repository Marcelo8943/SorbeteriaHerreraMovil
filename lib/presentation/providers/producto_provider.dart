import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:herrera_system/data/models/producto_catalogo_model.dart';
import 'package:herrera_system/services/producto_service.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _service;

  ProductoProvider(this._service);

  static const int pageSize = 10;

  List<ProductoCatalogoModel> productos = const [];
  ProductoEstadisticasModel? estadisticas;
  bool cargando = true;
  String? error;
  int currentPage = 1;
  int totalPages = 0;
  int totalRecords = 0;
  String search = '';
  int? lineId;
  int? presentationId;
  int? flavorId;
  bool? active;

  Timer? _searchTimer;
  int _requestVersion = 0;

  Future<void> cargar({int? page}) async {
    if (page != null) currentPage = page;
    final requestVersion = ++_requestVersion;
    cargando = true;
    error = null;
    notifyListeners();

    try {
      final catalogoFuture = _service.obtenerCatalogo(
        page: currentPage,
        pageSize: pageSize,
        search: search,
        lineId: lineId,
        presentationId: presentationId,
        flavorId: flavorId,
        active: active,
      );
      final estadisticasFuture = _service
          .obtenerEstadisticas()
          .then<ProductoEstadisticasModel?>((value) => value)
          .catchError((_) => null);

      final pagina = await catalogoFuture;
      if (requestVersion != _requestVersion) return;
      productos = pagina.productos;
      currentPage = pagina.currentPage;
      totalPages = pagina.totalPages;
      totalRecords = pagina.totalRecords;
      estadisticas = await estadisticasFuture;
    } catch (exception) {
      if (requestVersion != _requestVersion) return;
      error = _mensajeError(exception);
    } finally {
      if (requestVersion == _requestVersion) {
        cargando = false;
        notifyListeners();
      }
    }
  }

  void buscar(String value) {
    search = value;
    _searchTimer?.cancel();
    _searchTimer = Timer(
      const Duration(milliseconds: 350),
      () => cargar(page: 1),
    );
  }

  Future<void> aplicarFiltros({
    int? newLineId,
    int? newPresentationId,
    int? newFlavorId,
    bool? newActive,
  }) {
    lineId = newLineId;
    presentationId = newPresentationId;
    flavorId = newFlavorId;
    active = newActive;
    return cargar(page: 1);
  }

  static String _mensajeError(Object exception) =>
      exception.toString().replaceFirst(RegExp(r'^[^:]+: '), '');

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}
