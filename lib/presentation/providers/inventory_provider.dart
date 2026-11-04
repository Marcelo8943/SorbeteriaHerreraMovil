import 'package:flutter/foundation.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/inventory_filter_option.dart';
import 'package:herrera_system/data/models/inventory_page_model.dart';
import 'package:herrera_system/data/models/inventory_product_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';
import 'package:herrera_system/services/inventory_service.dart';

class InventoryProvider extends ChangeNotifier {
  InventoryProvider(this._service);

  static const int pageSize = 10;

  final InventoryService _service;
  List<InventoryProductModel> _products = [];
  List<InventoryFilterOption> _lines = [];
  List<InventoryFilterOption> _flavors = [];
  List<InventoryFilterOption> _presentations = [];
  InventoryStatsModel? _stats;
  String? _errorMessage;
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalRecords = 0;
  String _search = '';
  int? _lineId;
  int? _flavorId;
  int? _presentationId;
  bool? _lowStock;

  List<InventoryProductModel> get products => _products;
  List<InventoryFilterOption> get lines => _lines;
  List<InventoryFilterOption> get flavors => _flavors;
  List<InventoryFilterOption> get presentations => _presentations;
  InventoryStatsModel? get stats => _stats;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  int? get lineId => _lineId;
  int? get flavorId => _flavorId;
  int? get presentationId => _presentationId;
  bool? get lowStock => _lowStock;

  Future<void> loadInitial() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getInventory(
          page: _currentPage,
          pageSize: pageSize,
          search: _search,
          lineId: _lineId,
          flavorId: _flavorId,
          presentationId: _presentationId,
          lowStock: _lowStock,
        ),
        _service.getStats(),
        _service.getLines(),
        _service.getFlavors(),
        _service.getPresentations(),
      ]);

      _applyPage(results[0] as InventoryPageModel);
      _stats = results[1] as InventoryStatsModel;
      _lines = results[2] as List<InventoryFilterOption>;
      _flavors = results[3] as List<InventoryFilterOption>;
      _presentations = results[4] as List<InventoryFilterOption>;
    } on AppException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'No se pudo obtener el inventario.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyFilters({
    required String search,
    required int? lineId,
    required int? flavorId,
    required int? presentationId,
    required bool? lowStock,
  }) async {
    _search = search;
    _lineId = lineId;
    _flavorId = flavorId;
    _presentationId = presentationId;
    _lowStock = lowStock;
    _currentPage = 1;
    await _loadPage();
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > _totalPages || page == _currentPage) return;

    _currentPage = page;
    await _loadPage();
  }

  Future<void> _loadPage() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getInventory(
          page: _currentPage,
          pageSize: pageSize,
          search: _search,
          lineId: _lineId,
          flavorId: _flavorId,
          presentationId: _presentationId,
          lowStock: _lowStock,
        ),
        _service.getStats(),
      ]);

      _applyPage(results[0] as InventoryPageModel);
      _stats = results[1] as InventoryStatsModel;
    } on AppException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'No se pudo obtener el inventario.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyPage(InventoryPageModel page) {
    _products = page.products;
    _currentPage = page.currentPage;
    _totalPages = page.totalPages;
    _totalRecords = page.totalRecords;
  }
}
