import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';
import 'package:herrera_system/data/models/producto_catalogo_model.dart';

class DashboardStatsModel {
  final ProductoEstadisticasModel products;
  final ClienteEstadisticas customers;
  final InventoryStatsModel inventory;
  final SalesStatsModel sales;
  final InventoryMovementStatsModel movements;

  const DashboardStatsModel({
    required this.products,
    required this.customers,
    required this.inventory,
    required this.sales,
    required this.movements,
  });
}

class SalesStatsModel {
  final int salesThisMonth;
  final double totalIncomeThisMonth;
  final int productsSoldThisMonth;

  const SalesStatsModel({
    required this.salesThisMonth,
    required this.totalIncomeThisMonth,
    required this.productsSoldThisMonth,
  });

  factory SalesStatsModel.fromJson(Map<String, dynamic> json) {
    return SalesStatsModel(
      salesThisMonth: _intValue(json['salesThisMonth']),
      totalIncomeThisMonth: _doubleValue(json['totalIncomeThisMonth']),
      productsSoldThisMonth: _intValue(json['productsSoldThisMonth']),
    );
  }

  static int _intValue(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

  static double _doubleValue(dynamic value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '') ?? 0;
}
