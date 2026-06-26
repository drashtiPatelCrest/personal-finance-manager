import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_params.dart';
import '../entities/dashboard_snapshot.dart';
import '../repository/dashboard_repository.dart';

@injectable
class GetDashboardDataUseCase
    implements UseCase<DashboardSnapshot, GetDashboardParams> {
  GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<DashboardSnapshot> call(GetDashboardParams params) {
    return _repository.getDashboardData(params);
  }
}
