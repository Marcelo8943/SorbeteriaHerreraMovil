import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/restock_detail_model.dart';
import 'package:herrera_system/data/models/restock_statistics_model.dart';
import 'package:herrera_system/data/models/restocks_page_model.dart';

class RestocksRepository {
  final ApiClient _apiClient;

  RestocksRepository(this._apiClient);

  Future<RestockStatisticsModel> getStatistics() async {
    final data = await _getData(ApiConstants.restockStatistics);
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return RestockStatisticsModel.fromJson(data);
  }

  Future<RestocksPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
  }) async {
    final data = await _getData(
      ApiConstants.restocks,
      query: {
        'Page': '$page',
        'PageSize': '$pageSize',
        if (fromDate != null) 'FromDate': _dateQuery(fromDate),
        if (toDate != null) 'ToDate': _dateQuery(toDate),
        if (search != null && search.isNotEmpty) 'Search': search,
      },
    );
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return RestocksPageModel.fromJson(data);
  }

  Future<RestockDetailModel> getDetail(int id) async {
    final data = await _getData('${ApiConstants.restocks}/$id/detail');
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return RestockDetailModel.fromJson(data);
  }

  Future<dynamic> _getData(String path, {Map<String, String>? query}) async {
    final response = await _apiClient.get(path, query: query);
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ??
            'No se pudieron cargar los reabastecimientos.',
      );
    }
    if (!response.containsKey('data')) throw const ParsingException();
    return response['data'];
  }

  String _dateQuery(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
