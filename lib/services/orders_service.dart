import 'package:herrera_system/data/models/order_detail_model.dart';
import 'package:herrera_system/data/models/orders_page_model.dart';
import 'package:herrera_system/data/repository/orders_repository.dart';

class OrdersService {
  final OrdersRepository _repository;

  OrdersService(this._repository);

  Future<OrdersPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    int? orderStatusId,
    String? search,
  }) {
    return _repository.getAll(
      page: page,
      pageSize: pageSize,
      fromDate: fromDate,
      toDate: toDate,
      orderStatusId: orderStatusId,
      search: search,
    );
  }

  Future<OrderDetailModel> getById(int id) => _repository.getById(id);
}
