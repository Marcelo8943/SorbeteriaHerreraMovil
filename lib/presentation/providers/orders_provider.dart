import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/order_detail_model.dart';
import 'package:herrera_system/data/models/orders_page_model.dart';
import 'package:herrera_system/services/orders_service.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersService _service;

  OrdersProvider(this._service);

  OrdersPageModel? _page;
  OrdersPageModel? get page => _page;
  ViewStatus _listStatus = ViewStatus.initial;
  ViewStatus get listStatus => _listStatus;
  String? _listError;
  String? get listError => _listError;

  OrderDetailModel? _order;
  OrderDetailModel? get order => _order;
  ViewStatus _detailStatus = ViewStatus.initial;
  ViewStatus get detailStatus => _detailStatus;
  String? _detailError;
  String? get detailError => _detailError;

  Future<void> loadOrders({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    int? orderStatusId,
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
        orderStatusId: orderStatusId,
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

  Future<void> loadOrderDetail(int id) async {
    _detailStatus = ViewStatus.loading;
    _detailError = null;
    _order = null;
    notifyListeners();
    try {
      _order = await _service.getById(id);
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
