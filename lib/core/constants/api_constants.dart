import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  String get baseUrl => dotenv.env['BASE_API_URL'] ?? '';
  String get environment => dotenv.env['ENVIRONMENT'] ?? '';

  ApiConstants._privateConstructor();
  static final ApiConstants _instance = ApiConstants._privateConstructor();
  static ApiConstants get instance => _instance;

  static const String users = '/users';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String businessProfile = '/BusinessProfile';
  static const String inventory = '/Inventory';
  static const String inventoryStats = '/Inventory/stats';
  static const String lines = '/Lines';
  static const String flavors = '/Flavors';
  static const String presentations = '/Presentations';
  static const String inventoryMovements = '/InventoryMovements';
  static const String inventoryMovementStats = '/InventoryMovements/stats';

  static const Duration timeDuration = Duration(seconds: 30);
}
