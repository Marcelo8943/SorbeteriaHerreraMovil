import 'package:herrera_system/data/models/dashboard_stats_model.dart';
import 'package:herrera_system/data/repository/dashboard_repository.dart';

class DashboardService {
  final DashboardRepository _repository;

  DashboardService(this._repository);

  Future<DashboardStatsModel> getStats() => _repository.getStats();
}
