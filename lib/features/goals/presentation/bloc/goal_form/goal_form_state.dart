part of 'goal_form_bloc.dart';

final class GoalFormState extends BaseState {
  GoalFormState({
    super.status = BaseStatus.initial,
    super.message,
    this.goalId,
    this.deadline,
    this.isEditing = false,
    this.saved = false,
    this.initialName,
    this.initialTargetAmount,
    this.errorCode,
  });

  final String? goalId;
  final DateTime? deadline;
  final bool isEditing;
  final bool saved;
  final String? initialName;
  final double? initialTargetAmount;
  final GoalErrorCode? errorCode;

  factory GoalFormState.initial({DateTime? deadline}) {
    return GoalFormState(deadline: deadline);
  }

  GoalFormState copyWith({
    BaseStatus? status,
    String? message,
    String? goalId,
    DateTime? deadline,
    bool? isEditing,
    bool? saved,
    String? initialName,
    double? initialTargetAmount,
    GoalErrorCode? errorCode,
    bool clearError = false,
  }) {
    return GoalFormState(
      status: status ?? this.status,
      message: message ?? this.message,
      goalId: goalId ?? this.goalId,
      deadline: deadline ?? this.deadline,
      isEditing: isEditing ?? this.isEditing,
      saved: saved ?? this.saved,
      initialName: initialName ?? this.initialName,
      initialTargetAmount: initialTargetAmount ?? this.initialTargetAmount,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        goalId,
        deadline,
        isEditing,
        saved,
        initialName,
        initialTargetAmount,
        errorCode,
      ];
}
