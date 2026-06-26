part of 'recurring_list_bloc.dart';

sealed class RecurringListEvent extends Equatable {
  const RecurringListEvent();

  @override
  List<Object?> get props => [];
}

final class RecurringListStarted extends RecurringListEvent {
  const RecurringListStarted();
}

final class RecurringListSearchChanged extends RecurringListEvent {
  const RecurringListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class RecurringListStatusFilterChanged extends RecurringListEvent {
  const RecurringListStatusFilterChanged(this.isPaused);

  final bool? isPaused;

  @override
  List<Object?> get props => [isPaused];
}

final class RecurringListDeleteRequested extends RecurringListEvent {
  const RecurringListDeleteRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringListPauseRequested extends RecurringListEvent {
  const RecurringListPauseRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringListResumeRequested extends RecurringListEvent {
  const RecurringListResumeRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringListUpdated extends RecurringListEvent {
  const RecurringListUpdated(this.items);

  final List<RecurringTransaction> items;

  @override
  List<Object?> get props => [items];
}

final class RecurringListFailed extends RecurringListEvent {
  const RecurringListFailed(this.errorCode);

  final RecurringTransactionErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
