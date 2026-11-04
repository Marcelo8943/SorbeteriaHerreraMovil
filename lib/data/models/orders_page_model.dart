import 'order_list_item_model.dart';

class OrdersPageModel {
  final List<OrderListItemModel> orders;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const OrdersPageModel({
    required this.orders,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory OrdersPageModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'];
    if (items is! List) {
      throw const FormatException('Formato de lista de pedidos inválido.');
    }
    return OrdersPageModel(
      orders: items.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de pedido inválido.');
        }
        return OrderListItemModel.fromJson(item);
      }).toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
