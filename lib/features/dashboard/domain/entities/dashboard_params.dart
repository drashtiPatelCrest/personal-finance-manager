import 'package:equatable/equatable.dart';

class GetDashboardParams extends Equatable {
  const GetDashboardParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}
