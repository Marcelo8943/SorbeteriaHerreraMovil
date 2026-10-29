import 'package:flutter/foundation.dart';
import 'package:herrera_system/data/models/precio_general_model.dart';
import 'package:herrera_system/services/precio_service.dart';

class PrecioProvider extends ChangeNotifier {
  final PrecioService _service;

  PrecioProvider(this._service);

  List<PrecioGeneralModel> precios = const [];
  bool cargando = false;
  bool guardando = false;
  String? error;
  String lineaSeleccionada = 'Todas';

  List<String> get lineas => [
    'Todas',
    ...precios.map((precio) => precio.lineName).toSet().toList()..sort(),
  ];

  List<PrecioGeneralModel> get preciosVisibles => lineaSeleccionada == 'Todas'
      ? precios
      : precios
            .where((precio) => precio.lineName == lineaSeleccionada)
            .toList();

  int get combinacionesConPrecio => precios
      .where(
        (precio) => precio.retailPrice != null && precio.wholesalePrice != null,
      )
      .length;

  int get combinacionesPendientes => precios.length - combinacionesConPrecio;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      precios = await _service.obtenerPreciosGenerales();
      if (!lineas.contains(lineaSeleccionada)) lineaSeleccionada = 'Todas';
    } catch (exception) {
      error = exception.toString().replaceFirst(RegExp(r'^[^:]+: '), '');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void seleccionarLinea(String linea) {
    lineaSeleccionada = linea;
    notifyListeners();
  }

  Future<void> actualizarPrecios({
    required PrecioGeneralModel precio,
    required double retailPrice,
    required double wholesalePrice,
  }) async {
    guardando = true;
    error = null;
    notifyListeners();
    try {
      await _service.actualizarPreciosGenerales(
        linePresentationId: precio.linePresentationId,
        retailPrice: retailPrice,
        wholesalePrice: wholesalePrice,
      );
      await cargar();
    } catch (exception) {
      final mensaje = exception.toString().replaceFirst(
        RegExp(r'^[^:]+: '),
        '',
      );
      await cargar();
      error = mensaje;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }
}
