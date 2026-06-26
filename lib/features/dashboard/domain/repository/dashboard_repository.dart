import '../entities/dashboard_params.dart';
import '../entities/dashboard_snapshot.dart';

abstract class DashboardRepository {
  Future<DashboardSnapshot> getDashboardData(GetDashboardParams params);
}
