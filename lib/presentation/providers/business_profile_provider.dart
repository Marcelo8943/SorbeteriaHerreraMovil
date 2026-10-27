import 'package:flutter/foundation.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/business_profile_model.dart';
import 'package:herrera_system/services/business_profile_service.dart';

class BusinessProfileProvider extends ChangeNotifier {
  BusinessProfileProvider(this._service);

  final BusinessProfileService _service;
  BusinessProfileModel? _profile;
  String? _errorMessage;
  bool _isLoading = false;

  BusinessProfileModel? get profile => _profile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _service.getProfile();
    } on AppException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'No se pudo obtener la información del negocio.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
