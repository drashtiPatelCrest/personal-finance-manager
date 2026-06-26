part of 'recurring_detail_bloc.dart';

sealed class RecurringDetailEvent extends Equatable {
  const RecurringDetailEvent();

  @override
  List<Object?> get props => [];
}

final class RecurringDetailLoadRequested extends RecurringDetailEvent {
  const RecurringDetailLoadRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringDetailDeleteRequested extends RecurringDetailEvent {
  const RecurringDetailDeleteRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringDetailPauseRequested extends RecurringDetailEvent {
  const RecurringDetailPauseRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringDetailResumeRequested extends RecurringDetailEvent {
  const RecurringDetailResumeRequested(this.recurringId);

  final String recurringId;

  @override
  List<Object?> get props => [recurringId];
}

final class RecurringDetailUpdated extends RecurringDetailEvent {
  const RecurringDetailUpdated();
}
