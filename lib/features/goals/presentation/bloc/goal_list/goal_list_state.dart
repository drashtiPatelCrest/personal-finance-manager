part of 'goal_list_bloc.dart';

final class GoalListState extends BaseState {
  const GoalListState({
    super.status = BaseStatus.initial,
    super.message,
    this.goals = const [],
    this.progressMap = const {},
    this.selectedStatus,
    this.searchQuery = '',
    this.errorCode,
    this.errorNonce = 0,
  });

  final List<SavingsGoal> goals;
  final Map<String, GoalProgress> progressMap;
  final GoalStatus? selectedStatus;
  final String searchQuery;
  final GoalErrorCode? errorCode;
  final int errorNonce;

  GoalListState copyWith({
    BaseStatus? status,
    String? message,
    List<SavingsGoal>? goals,
    Map<String, GoalProgress>? progressMap,
    GoalStatus? selectedStatus,
    String? searchQuery,
    GoalErrorCode? errorCode,
    int? errorNonce,
    bool clearError = false,
    bool clearSelectedStatus = false,
  }) {
    return GoalListState(
      status: status ?? this.status,
      message: message ?? this.message,
      goals: goals ?? this.goals,
      progressMap: progressMap ?? this.progressMap,
      selectedStatus:
          clearSelectedStatus ? null : selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        goals,
        progressMap,
        selectedStatus,
        searchQuery,
        errorCode,
        errorNonce,
      ];
}
