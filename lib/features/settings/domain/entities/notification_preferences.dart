import 'package:equatable/equatable.dart';

class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.budgetWarningEnabled = true,
    this.budgetExceededEnabled = true,
    this.goalReminderEnabled = true,
    this.goalDeadlineEnabled = true,
    this.recurringReminderEnabled = true,
    this.monthlySummaryEnabled = true,
  });

  final bool budgetWarningEnabled;
  final bool budgetExceededEnabled;
  final bool goalReminderEnabled;
  final bool goalDeadlineEnabled;
  final bool recurringReminderEnabled;
  final bool monthlySummaryEnabled;

  NotificationPreferences copyWith({
    bool? budgetWarningEnabled,
    bool? budgetExceededEnabled,
    bool? goalReminderEnabled,
    bool? goalDeadlineEnabled,
    bool? recurringReminderEnabled,
    bool? monthlySummaryEnabled,
  }) {
    return NotificationPreferences(
      budgetWarningEnabled:
          budgetWarningEnabled ?? this.budgetWarningEnabled,
      budgetExceededEnabled:
          budgetExceededEnabled ?? this.budgetExceededEnabled,
      goalReminderEnabled: goalReminderEnabled ?? this.goalReminderEnabled,
      goalDeadlineEnabled: goalDeadlineEnabled ?? this.goalDeadlineEnabled,
      recurringReminderEnabled:
          recurringReminderEnabled ?? this.recurringReminderEnabled,
      monthlySummaryEnabled:
          monthlySummaryEnabled ?? this.monthlySummaryEnabled,
    );
  }

  @override
  List<Object?> get props => [
        budgetWarningEnabled,
        budgetExceededEnabled,
        goalReminderEnabled,
        goalDeadlineEnabled,
        recurringReminderEnabled,
        monthlySummaryEnabled,
      ];
}
