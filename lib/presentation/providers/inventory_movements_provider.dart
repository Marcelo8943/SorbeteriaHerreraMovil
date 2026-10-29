import 'package:flutter/foundation.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/inventory_movement_detail_item_model.dart';
import 'package:herrera_system/data/models/inventory_movement_header_model.dart';
import 'package:herrera_system/data/models/inventory_movement_model.dart';
import 'package:herrera_system/data/models/inventory_movement_page_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';
import 'package:herrera_system/services/inventory_movements_service.dart';

enum MovementDateRange { all, today, last7Days, thisMonth, thisYear }

class InventoryMovementsProvider extends ChangeNotifier {
  InventoryMovementsProvider(this._service);

  static const int pageSize = 10;

  final InventoryMovementsService _service;
  List<InventoryMovementModel> _movements = [];
  InventoryMovementStatsModel? _stats;
  String? _errorMessage;
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalRecords = 0;
  String _search = '';
  MovementDateRange _dateRange = MovementDateRange.all;
  InventoryMovementHeaderModel? _movementDetail;
  List<InventoryMovementDetailItemModel> _movementDetailItems = [];
  String? _detailErrorMessage;
  bool _isDetailLoading = false;

  List<InventoryMovementModel> get movements => _movements;
  InventoryMovementStatsModel? get stats => _stats;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  MovementDateRange get dateRange => _dateRange;
  InventoryMovementHeaderModel? get movementDetail => _movementDetail;
  List<InventoryMovementDetailItemModel> get movementDetailItems =>
      _movementDetailItems;
  String? get detailErrorMessage => _detailErrorMessage;
  bool get isDetailLoading => _isDetailLoading;

  Future<void> loadInitial() => _loadData();

  Future<void> applyFilters({
    required String search,
    required MovementDateRange dateRange,
  }) async {
    _search = search;
    _dateRange = dateRange;
    _currentPage = 1;
    await _loadData();
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > _totalPages || page == _currentPage) return;

    _currentPage = page;
    await _loadData();
  }

  Future<void> loadMovementDetail(int id) async {
    if (_isDetailLoading) return;

    _isDetailLoading = true;
    _detailErrorMessage = null;
    _movementDetail = null;
    _movementDetailItems = [];
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getMovementById(id),
        _service.getMovementDetails(id),
      ]);
      _movementDetail = results[0] as InventoryMovementHeaderModel;
      _movementDetailItems =
          results[1] as List<InventoryMovementDetailItemModel>;
    } on AppException catch (error) {
      _detailErrorMessage = error.message;
    } catch (_) {
      _detailErrorMessage = 'No se pudo obtener el detalle del movimiento.';
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dates = _datesFor(_dateRange);
      final results = await Future.wait([
        _service.getMovements(
          page: _currentPage,
          pageSize: pageSize,
          search: _search,
          fromDate: dates.$1,
          toDate: dates.$2,
        ),
        _service.getStats(),
      ]);

      _applyPage(results[0] as InventoryMovementPageModel);
      _stats = results[1] as InventoryMovementStatsModel;
    } on AppException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'No se pudieron obtener los movimientos de inventario.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  (DateTime?, DateTime?) _datesFor(MovementDateRange range) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return switch (range) {
      MovementDateRange.today => (
        DateTime(now.year, now.month, now.day),
        endOfToday,
      ),
      MovementDateRange.last7Days => (
        DateTime(now.year, now.month, now.day - 6),
        endOfToday,
      ),
      MovementDateRange.thisMonth => (
        DateTime(now.year, now.month),
        endOfToday,
      ),
      MovementDateRange.thisYear => (DateTime(now.year), endOfToday),
      MovementDateRange.all => (null, null),
    };
  }

  void _applyPage(InventoryMovementPageModel page) {
    _movements = page.movements;
    _currentPage = page.currentPage;
    _totalPages = page.totalPages;
    _totalRecords = page.totalRecords;
  }
}
