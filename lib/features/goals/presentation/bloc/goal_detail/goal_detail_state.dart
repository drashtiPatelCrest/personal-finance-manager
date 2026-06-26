part of 'goal_detail_bloc.dart';

final class GoalDetailState extends BaseState {
  const GoalDetailState({
    super.status = BaseStatus.initial,
    super.message,
    this.progress,
    this.errorCode,
    this.errorNonce = 0,
    this.isContributing = false,
    this.isDeleting = false,
    this.deleted = false,
    this.contributionAdded = false,
  });

  final GoalProgress? progress;
  final GoalErrorCode? errorCode;
  final int errorNonce;
  final bool isContributing;
  final bool isDeleting;
  final bool deleted;
  final bool contributionAdded;

  GoalDetailState copyWith({
    BaseStatus? status,
    String? message,
    GoalProgress? progress,
    GoalErrorCode? errorCode,
    int? errorNonce,
    bool? isContributing,
    bool? isDeleting,
    bool? deleted,
    bool? contributionAdded,
    bool clearError = false,
  }) {
    return GoalDetailState(
      status: status ?? this.status,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorNonce: errorNonce ?? this.errorNonce,
      isContributing: isContributing ?? this.isContributing,
      isDeleting: isDeleting ?? this.isDeleting,
      deleted: deleted ?? this.deleted,
      contributionAdded: contributionAdded ?? this.contributionAdded,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        progress,
        errorCode,
        errorNonce,
        isContributing,
        isDeleting,
        deleted,
        contributionAdded,
      ];
}
