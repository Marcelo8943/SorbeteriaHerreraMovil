import 'package:herrera_system/data/models/sale_detail_item_model.dart';
import 'package:herrera_system/data/models/sale_header_detail_model.dart';
import 'package:herrera_system/data/models/sale_payment_model.dart';
import 'package:herrera_system/data/models/sales_page_model.dart';
import 'package:herrera_system/data/models/sales_stats_model.dart';
import 'package:herrera_system/data/repository/sales_repository.dart';

class SalesService {
  final SalesRepository _repository;

  SalesService(this._repository);

  Future<SalesStatsModel> getStats() => _repository.getStats();

  Future<SalesPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? startDate,
    DateTime? endDate,
    int? saleTypeId,
    String? search,
  }) {
    return _repository.getAll(
      page: page,
      pageSize: pageSize,
      startDate: startDate,
      endDate: endDate,
      saleTypeId: saleTypeId,
      search: search,
    );
  }

  Future<SaleHeaderDetailModel> getById(int id) => _repository.getById(id);

  Future<List<SaleDetailItemModel>> getDetails(int id) =>
      _repository.getDetails(id);

  Future<List<SalePaymentModel>> getPayments(int id) =>
      _repository.getPayments(id);
}
