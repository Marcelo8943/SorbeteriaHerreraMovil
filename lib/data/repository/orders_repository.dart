import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/order_detail_model.dart';
import 'package:herrera_system/data/models/orders_page_model.dart';

class OrdersRepository {
  final ApiClient _apiClient;

  OrdersRepository(this._apiClient);

  Future<OrdersPageModel> getAll({
    required int page,
    int pageSize = 10,
    DateTime? fromDate,
    DateTime? toDate,
    int? orderStatusId,
    String? search,
  }) async {
    final data = await _getData(
      ApiConstants.orders,
      query: {
        'Page': '$page',
        'PageSize': '$pageSize',
        if (fromDate != null) 'FromDate': _dateQuery(fromDate),
        if (toDate != null) 'ToDate': _dateQuery(toDate),
        if (orderStatusId != null) 'OrderStatusId': '$orderStatusId',
        if (search != null && search.isNotEmpty) 'Search': search,
      },
    );
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return OrdersPageModel.fromJson(data);
  }

  Future<OrderDetailModel> getById(int id) async {
    final data = await _getData('${ApiConstants.orders}/$id');
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return OrderDetailModel.fromJson(data);
  }

  Future<dynamic> _getData(String path, {Map<String, String>? query}) async {
    final response = await _apiClient.get(path, query: query);
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (response['success'] == false) {
      throw ServerException(
        response['message']?.toString() ?? 'No se pudieron cargar los pedidos.',
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
