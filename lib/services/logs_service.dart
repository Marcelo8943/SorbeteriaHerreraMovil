import 'package:herrera_system/data/models/log_model.dart';
import 'package:herrera_system/data/repository/logs_repository.dart';

class LogsService {
  final LogsRepository _repository;

  LogsService(this._repository);

  Future<LogPageModel> getLogs({
    required int page,
    int pageSize = 10,
    String? modulo,
    String? method,
    String? userId,
    bool? success,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return _repository.getLogs(
      page: page,
      pageSize: pageSize,
      modulo: modulo,
      method: method,
      userId: userId,
      success: success,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<LogDetailModel> getLogById(String id) {
    return _repository.getLogById(id);
  }
}
