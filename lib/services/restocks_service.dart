import 'package:herrera_system/data/models/restock_detail_model.dart';
import 'package:herrera_system/data/models/restock_statistics_model.dart';
import 'package:herrera_system/data/models/restocks_page_model.dart';
import 'package:herrera_system/data/repository/restocks_repository.dart';

class RestocksService {
  final RestocksRepository _repository;

  RestocksService(this._repository);

  Future<RestockStatisticsModel> getStatistics() =>
      _repository.getStatistics();

  Future<RestocksPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) {
    return _repository.getAll(
      page: page,
      pageSize: pageSize,
      fromDate: fromDate,
      toDate: toDate,
      search: search,
    );
  }

  Future<RestockDetailModel> getDetail(int id) => _repository.getDetail(id);
}
