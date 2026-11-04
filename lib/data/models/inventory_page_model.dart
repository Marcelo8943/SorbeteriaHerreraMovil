import 'inventory_product_model.dart';

class InventoryPageModel {
  const InventoryPageModel({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
  });

  final List<InventoryProductModel> products;
  final int currentPage;
  final int totalPages;
  final int totalRecords;
}
