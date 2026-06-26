import 'package:equatable/equatable.dart';

enum BaseStatus { initial, loading, success, failure }

abstract class BaseState extends Equatable {
  const BaseState({
    this.status = BaseStatus.initial,
    this.message,
  });

  final BaseStatus status;
  final String? message;

  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isSuccess => status == BaseStatus.success;
  bool get isFailure => status == BaseStatus.failure;

  @override
  List<Object?> get props => [status, message];
}
