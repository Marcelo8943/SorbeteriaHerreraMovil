import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/sale_detail_item_model.dart';
import 'package:herrera_system/data/models/sale_header_detail_model.dart';
import 'package:herrera_system/data/models/sale_payment_model.dart';
import 'package:herrera_system/data/models/sales_page_model.dart';
import 'package:herrera_system/data/models/sales_stats_model.dart';

class SalesRepository {
  final ApiClient _apiClient;

  SalesRepository(this._apiClient);

  Future<SalesStatsModel> getStats() async {
    final data = await _getData(ApiConstants.salesStats);
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return SalesStatsModel.fromJson(data);
  }

  Future<SalesPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? startDate,
    DateTime? endDate,
    int? saleTypeId,
    String? search,
  }) async {
    final data = await _getData(
      ApiConstants.sales,
      query: {
        'Page': '$page',
        'PageSize': '$pageSize',
        if (startDate != null) 'StartDate': _dateQuery(startDate),
        if (endDate != null) 'EndDate': _dateQuery(endDate),
        if (saleTypeId != null) 'SaleTypeId': '$saleTypeId',
        if (search != null && search.isNotEmpty) 'Search': search,
      },
    );
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return SalesPageModel.fromJson(data);
  }

  Future<SaleHeaderDetailModel> getById(int id) async {
    final data = await _getData('${ApiConstants.sales}/$id');
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return SaleHeaderDetailModel.fromJson(data);
  }

  Future<List<SaleDetailItemModel>> getDetails(int id) async {
    final data = await _getData('${ApiConstants.sales}/$id/details');
    return _parseList(data, SaleDetailItemModel.fromJson);
  }

  Future<List<SalePaymentModel>> getPayments(int id) async {
    final data = await _getData('${ApiConstants.sales}/$id/payments');
    return _parseList(data, SalePaymentModel.fromJson);
  }

  Future<dynamic> _getData(String path, {Map<String, String>? query}) async {
    final response = await _apiClient.get(path, query: query);
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudieron cargar las ventas.',
      );
    }
    if (!response.containsKey('data')) throw const ParsingException();
    return response['data'];
  }

  List<T> _parseList<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
    if (data is! List) throw const ParsingException();
    return data.map((item) {
      if (item is! Map<String, dynamic>) throw const ParsingException();
      return fromJson(item);
    }).toList();
  }

  String _dateQuery(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
