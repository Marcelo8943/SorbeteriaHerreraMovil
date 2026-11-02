import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/restock_detail_model.dart';
import 'package:herrera_system/data/models/restock_statistics_model.dart';
import 'package:herrera_system/data/models/restocks_page_model.dart';
import 'package:herrera_system/services/restocks_service.dart';

class RestocksProvider extends ChangeNotifier {
  final RestocksService _service;

  RestocksProvider(this._service);

  RestockStatisticsModel? _statistics;
  RestockStatisticsModel? get statistics => _statistics;
  ViewStatus _statisticsStatus = ViewStatus.initial;
  ViewStatus get statisticsStatus => _statisticsStatus;
  String? _statisticsError;
  String? get statisticsError => _statisticsError;

  RestocksPageModel? _page;
  RestocksPageModel? get page => _page;
  ViewStatus _listStatus = ViewStatus.initial;
  ViewStatus get listStatus => _listStatus;
  String? _listError;
  String? get listError => _listError;

  RestockDetailModel? _detail;
  RestockDetailModel? get detail => _detail;
  ViewStatus _detailStatus = ViewStatus.initial;
  ViewStatus get detailStatus => _detailStatus;
  String? _detailError;
  String? get detailError => _detailError;

  Future<void> loadStatistics() async {
    _statisticsStatus = ViewStatus.loading;
    _statisticsError = null;
    notifyListeners();
    try {
      _statistics = await _service.getStatistics();
      _statisticsStatus = ViewStatus.success;
    } on AppException catch (error) {
      _statisticsError = error.message;
      _statisticsStatus = ViewStatus.error;
    } catch (error) {
      _statisticsError = error.toString();
      _statisticsStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadRestocks({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    _listStatus = ViewStatus.loading;
    _listError = null;
    notifyListeners();
    try {
      _page = await _service.getAll(
        page: page,
        pageSize: pageSize,
        fromDate: fromDate,
        toDate: toDate,
        search: search,
      );
      _listStatus = ViewStatus.success;
    } on AppException catch (error) {
      _listError = error.message;
      _listStatus = ViewStatus.error;
    } catch (error) {
      _listError = error.toString();
      _listStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadDetail(int id) async {
    _detailStatus = ViewStatus.loading;
    _detailError = null;
    _detail = null;
    notifyListeners();
    try {
      _detail = await _service.getDetail(id);
      _detailStatus = ViewStatus.success;
    } on AppException catch (error) {
      _detailError = error.message;
      _detailStatus = ViewStatus.error;
    } catch (error) {
      _detailError = error.toString();
      _detailStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
