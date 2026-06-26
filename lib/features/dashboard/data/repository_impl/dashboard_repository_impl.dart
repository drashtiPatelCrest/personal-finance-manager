import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_params.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../datasource/dashboard_local_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dataSource);

  final DashboardLocalDataSource _dataSource;

  @override
  Future<DashboardSnapshot> getDashboardData(GetDashboardParams params) {
    return _dataSource.getDashboardData(params);
  }
}
