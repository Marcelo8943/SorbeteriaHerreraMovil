import 'restock_list_item_model.dart';

class RestocksPageModel {
  final List<RestockListItemModel> restocks;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const RestocksPageModel({
    required this.restocks,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory RestocksPageModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'];
    if (items is! List) {
      throw const FormatException('Formato de lista de reabastecimientos inválido.');
    }
    return RestocksPageModel(
      restocks: items.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de reabastecimiento inválido.');
        }
        return RestockListItemModel.fromJson(item);
      }).toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
