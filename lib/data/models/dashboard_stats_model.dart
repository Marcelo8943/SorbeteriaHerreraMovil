import 'package:herrera_system/data/models/cliente_model.dart';
import 'package:herrera_system/data/models/inventory_movement_stats_model.dart';
import 'package:herrera_system/data/models/inventory_stats_model.dart';
import 'package:herrera_system/data/models/producto_catalogo_model.dart';
import 'package:herrera_system/data/models/sales_stats_model.dart';

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
