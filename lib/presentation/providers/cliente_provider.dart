import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/services/cliente_service.dart';

class ClienteProvider extends ChangeNotifier {
  final ClienteService _service;
  ClienteProvider(this._service);

  static const int pageSize = 10;
  List<ClienteModel> clientes = const [];
  ClienteEstadisticas? estadisticas;
  bool cargando = true;
  String? error;
  int currentPage = 1;
  int totalPages = 0;
  int totalRecords = 0;
  String search = '';
  int? departmentId;
  int? municipalityId;
  Timer? _searchTimer;
  int _requestVersion = 0;

  Future<void> cargar({int? page}) async {
    if (page != null) currentPage = page;
    final requestVersion = ++_requestVersion;
    cargando = true;
    error = null;
    notifyListeners();

    try {
      final paginaFuture = _service.obtenerClientes(
        page: currentPage,
        pageSize: pageSize,
        search: search,
        departmentId: departmentId,
        municipalityId: municipalityId,
      );
      final estadisticasFuture = _service
          .obtenerEstadisticas()
          .then<ClienteEstadisticas?>((value) => value)
          .catchError((_) => null);
      final pagina = await paginaFuture;
      if (requestVersion != _requestVersion) return;
      clientes = pagina.clientes;
      currentPage = pagina.currentPage;
      totalPages = pagina.totalPages;
      totalRecords = pagina.totalRecords;
      // Las estadísticas son complementarias; la lista puede mostrarse igual.
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
    _searchTimer = Timer(const Duration(milliseconds: 350), () => cargar(page: 1));
  }

  Future<void> aplicarFiltros({int? newDepartmentId, int? newMunicipalityId}) {
    departmentId = newDepartmentId;
    municipalityId = newMunicipalityId;
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
