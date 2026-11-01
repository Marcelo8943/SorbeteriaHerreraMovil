import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/dashboard_stats_model.dart';
import 'package:herrera_system/services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service;

  DashboardProvider(this._service);

  DashboardStatsModel? _stats;
  DashboardStatsModel? get stats => _stats;

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadStats() async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await _service.getStats();
      _status = ViewStatus.success;
    } on AppException catch (error) {
      _errorMessage = error.message;
      _status = ViewStatus.error;
    } catch (error) {
      _errorMessage = error.toString();
      _status = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
