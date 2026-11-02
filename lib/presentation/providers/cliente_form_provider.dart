import 'package:flutter/foundation.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/services/cliente_service.dart';

class ClienteFormProvider extends ChangeNotifier {
  final ClienteService _service;

  ClienteFormProvider(this._service);

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> crearCliente({
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
  }) => _guardar(() async {
    await _service.crearCliente(
      municipalityId: municipalityId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      pointOfSale: pointOfSale,
      posAddress: posAddress,
    );
  });

  Future<bool> actualizarCliente({
    required int id,
    required bool isActive,
    required int municipalityId,
    required String firstName,
    required String lastName,
    required String phone,
    required String pointOfSale,
    required String posAddress,
  }) => _guardar(() async {
    await _service.actualizarCliente(
      id: id,
      isActive: isActive,
      municipalityId: municipalityId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      pointOfSale: pointOfSale,
      posAddress: posAddress,
    );
  });

  Future<bool> _guardar(Future<void> Function() action) async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      _status = ViewStatus.success;
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst(RegExp(r'^[^:]+: '), '');
      _status = ViewStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _status = ViewStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
