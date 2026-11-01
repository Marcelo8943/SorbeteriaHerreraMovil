import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/sale_detail_item_model.dart';
import 'package:herrera_system/data/models/sale_header_detail_model.dart';
import 'package:herrera_system/data/models/sale_payment_model.dart';
import 'package:herrera_system/data/models/sales_page_model.dart';
import 'package:herrera_system/data/models/sales_stats_model.dart';
import 'package:herrera_system/services/sales_service.dart';

class SalesProvider extends ChangeNotifier {
  final SalesService _service;

  SalesProvider(this._service);

  SalesStatsModel? _stats;
  SalesStatsModel? get stats => _stats;
  ViewStatus _statsStatus = ViewStatus.initial;
  ViewStatus get statsStatus => _statsStatus;
  String? _statsError;
  String? get statsError => _statsError;

  SalesPageModel? _page;
  SalesPageModel? get page => _page;
  final Map<int, String> _availableSaleTypes = {};
  Map<int, String> get availableSaleTypes =>
      Map<int, String>.unmodifiable(_availableSaleTypes);
  ViewStatus _listStatus = ViewStatus.initial;
  ViewStatus get listStatus => _listStatus;
  String? _listError;
  String? get listError => _listError;

  SaleHeaderDetailModel? _sale;
  SaleHeaderDetailModel? get sale => _sale;
  List<SaleDetailItemModel> _details = [];
  List<SaleDetailItemModel> get details => _details;
  List<SalePaymentModel> _payments = [];
  List<SalePaymentModel> get payments => _payments;
  ViewStatus _detailStatus = ViewStatus.initial;
  ViewStatus get detailStatus => _detailStatus;
  String? _detailError;
  String? get detailError => _detailError;

  Future<void> loadStats() async {
    _statsStatus = ViewStatus.loading;
    _statsError = null;
    notifyListeners();
    try {
      _stats = await _service.getStats();
      _statsStatus = ViewStatus.success;
    } on AppException catch (error) {
      _statsError = error.message;
      _statsStatus = ViewStatus.error;
    } catch (error) {
      _statsError = error.toString();
      _statsStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadSales({
    required int page,
    int pageSize = 10,
    DateTime? startDate,
    DateTime? endDate,
    int? saleTypeId,
    String? search,
  }) async {
    _listStatus = ViewStatus.loading;
    _listError = null;
    notifyListeners();
    try {
      _page = await _service.getAll(
        page: page,
        pageSize: pageSize,
        startDate: startDate,
        endDate: endDate,
        saleTypeId: saleTypeId,
        search: search,
      );
      for (final sale in _page!.sales) {
        _availableSaleTypes.putIfAbsent(sale.saleTypeId, () => sale.saleTypeName);
      }
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

  Future<void> loadSaleDetail(int id) async {
    _detailStatus = ViewStatus.loading;
    _detailError = null;
    _sale = null;
    _details = [];
    _payments = [];
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getById(id),
        _service.getDetails(id),
        _service.getPayments(id),
      ]);
      _sale = results[0] as SaleHeaderDetailModel;
      _details = results[1] as List<SaleDetailItemModel>;
      _payments = results[2] as List<SalePaymentModel>;
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
