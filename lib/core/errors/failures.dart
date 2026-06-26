import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}
