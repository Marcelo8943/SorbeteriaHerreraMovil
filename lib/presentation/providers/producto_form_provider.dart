import 'package:flutter/foundation.dart';
import 'package:herrera_system/services/producto_service.dart';

class ProductoFormProvider extends ChangeNotifier {
  final ProductoService _service;
  ProductoFormProvider(this._service);

  bool guardando = false;
  String? error;

  Future<bool> guardar({
    int? id,
    required int linePresentationId,
    required int flavorId,
    required String nombre,
    required String? imagenUrl,
    required int stockMinimo,
    required bool activo,
  }) async {
    guardando = true;
    error = null;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        'linePresentationId': linePresentationId,
        'flavorId': flavorId,
        'productName': nombre,
        'imageUrl': imagenUrl,
        'minimumStock': stockMinimo,
        if (id != null) 'isActive': activo,
      };
      if (id == null) {
        await _service.crearProducto(body: body);
      } else {
        await _service.actualizarProducto(id: id, body: body);
      }
      return true;
    } catch (exception) {
      error = exception.toString().replaceFirst(RegExp(r'^[^:]+: '), '');
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }
}
