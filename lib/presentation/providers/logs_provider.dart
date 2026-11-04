import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/log_model.dart';
import 'package:herrera_system/services/logs_service.dart';

class LogsProvider extends ChangeNotifier {
  final LogsService _service;

  LogsProvider(this._service);

  LogPageModel? _page;
  LogPageModel? get page => _page;

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LogDetailModel? _detail;
  LogDetailModel? get detail => _detail;

  ViewStatus _detailStatus = ViewStatus.initial;
  ViewStatus get detailStatus => _detailStatus;

  String? _detailErrorMessage;
  String? get detailErrorMessage => _detailErrorMessage;

  Future<void> loadLogs({
    required int page,
    int pageSize = 10,
    String? modulo,
    String? method,
    String? userId,
    bool? success,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _page = await _service.getLogs(
        page: page,
        pageSize: pageSize,
        modulo: modulo,
        method: method,
        userId: userId,
        success: success,
        fromDate: fromDate,
        toDate: toDate,
      );
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

  Future<void> loadLogDetail(String id) async {
    _detailStatus = ViewStatus.loading;
    _detailErrorMessage = null;
    _detail = null;
    notifyListeners();

    try {
      _detail = await _service.getLogById(id);
      _detailStatus = ViewStatus.success;
    } on AppException catch (error) {
      _detailErrorMessage = error.message;
      _detailStatus = ViewStatus.error;
    } catch (error) {
      _detailErrorMessage = error.toString();
      _detailStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
