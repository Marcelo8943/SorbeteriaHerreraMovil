import 'sale_list_item_model.dart';

class SalesPageModel {
  final List<SaleListItemModel> sales;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const SalesPageModel({
    required this.sales,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory SalesPageModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'];
    if (items is! List) {
      throw const FormatException('Formato de lista de ventas inválido.');
    }

    return SalesPageModel(
      sales: items.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de venta inválido.');
        }
        return SaleListItemModel.fromJson(item);
      }).toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
