import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/log_model.dart';

class LogsRepository {
  final ApiClient _apiClient;

  LogsRepository(this._apiClient);

  Future<LogPageModel> getLogs({
    required int page,
    int pageSize = 10,
    String? modulo,
    String? method,
    String? userId,
    bool? success,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.logs,
      query: {
        'Page': '$page',
        'PageSize': '$pageSize',
        if (modulo != null && modulo.isNotEmpty) 'Modulo': modulo,
        if (method != null && method.isNotEmpty) 'Method': method,
        if (userId != null && userId.isNotEmpty) 'UserId': userId,
        if (success != null) 'Success': '$success',
        if (fromDate != null) 'FromDate': _dateQuery(fromDate),
        if (toDate != null) 'ToDate': _dateQuery(toDate),
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudieron cargar los logs.',
      );
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    return LogPageModel.fromJson(data);
  }

  Future<LogDetailModel> getLogById(String id) async {
    final response = await _apiClient.get('${ApiConstants.logs}/$id');

    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudo cargar el detalle del log.',
      );
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    return LogDetailModel.fromJson(data);
  }

  String _dateQuery(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
