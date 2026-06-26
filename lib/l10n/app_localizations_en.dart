// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Personal Finance Manager';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardTotalIncomeLabel => 'Total income';

  @override
  String get dashboardTotalExpenseLabel => 'Total expense';

  @override
  String get dashboardTotalSavingsLabel => 'Total savings';

  @override
  String get dashboardNetBalanceLabel => 'Net balance';

  @override
  String get dashboardBudgetUsageTitle => 'Budget usage';

  @override
  String dashboardActiveGoalsTitle(int count) {
    return 'Active goals ($count)';
  }

  @override
  String get dashboardIncomeExpenseChartTitle => 'Income vs expense';

  @override
  String get dashboardMonthlyTrendChartTitle => 'Monthly trend';

  @override
  String get dashboardCategoryChartTitle => 'Spending by category';

  @override
  String get dashboardChartEmptyMessage => 'No data for the selected period.';

  @override
  String get dashboardQuickActionsTitle => 'Quick actions';

  @override
  String get dashboardQuickAddTransaction => 'Add transaction';

  @override
  String get dashboardQuickAddBudget => 'Add budget';

  @override
  String get dashboardQuickAddGoal => 'Add goal';

  @override
  String get dashboardQuickViewTransactions => 'View transactions';

  @override
  String get dashboardRangeThisMonth => 'This month';

  @override
  String get dashboardRangeLastMonth => 'Last month';

  @override
  String get dashboardRangeLastThreeMonths => 'Last 3 months';

  @override
  String get dashboardRangeLastSixMonths => 'Last 6 months';

  @override
  String get dashboardRangeThisYear => 'This year';

  @override
  String get dashboardRefreshAction => 'Refresh';

  @override
  String get dashboardViewAllAction => 'View all';

  @override
  String get dashboardEmptyTitle => 'Your dashboard is empty';

  @override
  String get dashboardEmptyMessage =>
      'Add transactions, budgets, or goals to see your financial overview.';

  @override
  String get dashboardRangeEmptyTitle => 'No data for this period';

  @override
  String get dashboardRangeEmptyMessage =>
      'Try a different date range or add transactions for this period.';

  @override
  String get dashboardErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get reportListTitle => 'Financial Reports';

  @override
  String get reportTypeMonthly => 'Monthly Report';

  @override
  String get reportTypeYearly => 'Yearly Report';

  @override
  String get reportTypeCategory => 'Category Report';

  @override
  String get reportTypeBudget => 'Budget Analysis';

  @override
  String get reportTypeGoal => 'Goal Progress';

  @override
  String get reportTypeMonthlyDescription =>
      'Income, expenses, and trends for a selected month.';

  @override
  String get reportTypeYearlyDescription =>
      'Annual overview with monthly breakdown.';

  @override
  String get reportTypeCategoryDescription =>
      'Spending breakdown by expense category.';

  @override
  String get reportTypeBudgetDescription =>
      'Budget usage, warnings, and exceeded limits.';

  @override
  String get reportTypeGoalDescription =>
      'Savings goals progress and completion status.';

  @override
  String get reportRangeThisMonth => 'This month';

  @override
  String get reportRangeLastMonth => 'Last month';

  @override
  String get reportRangeLastThreeMonths => 'Last 3 months';

  @override
  String get reportRangeLastSixMonths => 'Last 6 months';

  @override
  String get reportRangeThisYear => 'This year';

  @override
  String get reportTotalIncomeLabel => 'Total income';

  @override
  String get reportTotalExpenseLabel => 'Total expense';

  @override
  String get reportNetBalanceLabel => 'Net balance';

  @override
  String get reportTransactionCountLabel => 'Transactions';

  @override
  String get reportTotalSavingsLabel => 'Total savings';

  @override
  String get reportTotalBudgetsLabel => 'Total budgets';

  @override
  String get reportTotalSpentLabel => 'Total spent';

  @override
  String get reportExceededBudgetsLabel => 'Exceeded';

  @override
  String get reportWarningBudgetsLabel => 'At risk';

  @override
  String get reportActiveGoalsLabel => 'Active goals';

  @override
  String get reportCompletedGoalsLabel => 'Completed';

  @override
  String get reportBudgetSectionTitle => 'Budget usage';

  @override
  String get reportGoalSectionTitle => 'Goal progress';

  @override
  String get reportEmptyTitle => 'No report data';

  @override
  String get reportEmptyMessage =>
      'Adjust filters or add data to generate this report.';

  @override
  String get reportErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get reportRefreshAction => 'Refresh';

  @override
  String get exportTitle => 'Export Data';

  @override
  String get exportDescription =>
      'Export your financial data as PDF or CSV files. Files are saved locally and can be shared.';

  @override
  String get exportDataTypeTransactions => 'Transactions';

  @override
  String get exportDataTypeBudgets => 'Budgets';

  @override
  String get exportDataTypeGoals => 'Goals';

  @override
  String get exportDataTypeReports => 'Reports';

  @override
  String get exportDataTypeTransactionsDescription =>
      'Export all transactions with summary and charts.';

  @override
  String get exportDataTypeBudgetsDescription =>
      'Export budgets with usage and status.';

  @override
  String get exportDataTypeGoalsDescription =>
      'Export savings goals with progress.';

  @override
  String get exportDataTypeReportsDescription =>
      'Export all financial reports.';

  @override
  String get exportFormatPdf => 'Export PDF';

  @override
  String get exportFormatCsv => 'Export CSV';

  @override
  String get exportUseDateFilterLabel => 'Filter by date range';

  @override
  String get exportSummaryTitle => 'Summary';

  @override
  String get exportGeneratedAtLabel => 'Generated at';

  @override
  String get exportDateRangeLabel => 'Date range';

  @override
  String get exportAllDatesLabel => 'All dates';

  @override
  String get exportIncomeLabel => 'Income';

  @override
  String get exportExpenseLabel => 'Expense';

  @override
  String get exportNetBalanceLabel => 'Net balance';

  @override
  String get exportTransactionCountLabel => 'Transactions';

  @override
  String get exportIdLabel => 'ID';

  @override
  String get exportTypeLabel => 'Type';

  @override
  String get exportAmountLabel => 'Amount';

  @override
  String get exportDateLabel => 'Date';

  @override
  String get exportNoteLabel => 'Note';

  @override
  String get exportCategoryLabel => 'Category';

  @override
  String get exportNameLabel => 'Name';

  @override
  String get exportTargetLabel => 'Target';

  @override
  String get exportCurrentLabel => 'Current';

  @override
  String get exportDeadlineLabel => 'Deadline';

  @override
  String get exportStatusLabel => 'Status';

  @override
  String get exportSpentLabel => 'Spent';

  @override
  String get exportRemainingLabel => 'Remaining';

  @override
  String get exportUsageLabel => 'Usage';

  @override
  String get exportCompletionLabel => 'Completion';

  @override
  String exportSuccessMessage(String fileName) {
    return 'Saved $fileName';
  }

  @override
  String get exportShareTitle => 'Share export?';

  @override
  String get exportShareMessage =>
      'Your file was saved locally. Would you like to share it now?';

  @override
  String get exportShareAction => 'Share';

  @override
  String get exportShareDismissAction => 'Not now';

  @override
  String get exportErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get exportErrorNoData => 'No data available to export.';

  @override
  String get exportErrorFileWrite => 'Failed to save the export file.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsCurrencyLabel => 'Currency';

  @override
  String get settingsCurrencyUsd => 'US Dollar';

  @override
  String get settingsCurrencyEur => 'Euro';

  @override
  String get settingsCurrencyGbp => 'British Pound';

  @override
  String get settingsCurrencyInr => 'Indian Rupee';

  @override
  String get settingsCurrencyJpy => 'Japanese Yen';

  @override
  String get settingsCurrencyCad => 'Canadian Dollar';

  @override
  String get settingsCurrencyAud => 'Australian Dollar';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Choose which reminders you want to receive';

  @override
  String get settingsNotificationBudgetWarning => 'Budget approaching limit';

  @override
  String get settingsNotificationBudgetExceeded => 'Budget exceeded';

  @override
  String get settingsNotificationGoalReminder => 'Goal contribution reminder';

  @override
  String get settingsNotificationGoalDeadline => 'Goal deadline reminder';

  @override
  String get settingsNotificationRecurringReminder =>
      'Recurring transaction reminder';

  @override
  String get settingsNotificationMonthlySummary => 'Monthly summary reminder';

  @override
  String get settingsExportPreferencesTitle => 'Export defaults';

  @override
  String get settingsExportPreferencesSubtitle =>
      'Default options used on the export screen';

  @override
  String get settingsExportUseDateFilter => 'Use date range filter by default';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsDeleteAccountButton => 'Delete account';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Delete account?';

  @override
  String get settingsDeleteAccountConfirmMessage =>
      'This will permanently delete your account and all financial data on this device. This action cannot be undone.';

  @override
  String get settingsErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get settingsErrorDeleteAccountFailed =>
      'Failed to delete account. Please try again.';

  @override
  String get authTitle => 'Authentication';

  @override
  String get languageEnglish => 'English';

  @override
  String get widgetActionConfirm => 'Confirm';

  @override
  String get widgetActionCancel => 'Cancel';

  @override
  String get widgetActionClose => 'Close';

  @override
  String get widgetActionRetry => 'Retry';

  @override
  String get widgetSearchPlaceholder => 'Search';

  @override
  String get widgetLoading => 'Loading';

  @override
  String get widgetErrorTitle => 'Something went wrong';

  @override
  String get widgetErrorMessage =>
      'An unexpected error occurred. Please try again.';

  @override
  String get widgetEmptyTitle => 'Nothing here yet';

  @override
  String get widgetEmptyMessage => 'There is no content to display.';

  @override
  String get widgetPreviousPage => 'Previous page';

  @override
  String get widgetNextPage => 'Next page';

  @override
  String widgetPageIndicator(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get widgetImageLoadError => 'Failed to load image';

  @override
  String get widgetConfirmationTitle => 'Confirm action';

  @override
  String get widgetConfirmationMessage => 'Are you sure you want to continue?';

  @override
  String get widgetDismiss => 'Dismiss';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Sign in to manage your personal finances';

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authRegisterSubtitle => 'Set up your offline finance profile';

  @override
  String get authForgotPasswordTitle => 'Reset password';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email and choose a new password';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authDisplayNameLabel => 'Display name';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authRegisterButton => 'Create account';

  @override
  String get authResetPasswordButton => 'Reset password';

  @override
  String get authForgotPasswordLink => 'Forgot password?';

  @override
  String get authRegisterLink => 'Register';

  @override
  String get authLoginLink => 'Sign in';

  @override
  String get authBackToLoginLink => 'Back to sign in';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account?';

  @override
  String get authHaveAccountPrompt => 'Already have an account?';

  @override
  String get authPasswordResetSuccess =>
      'Password updated successfully. Please sign in.';

  @override
  String get authSignOutButton => 'Sign out';

  @override
  String get authErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 8 characters.';

  @override
  String get authErrorDisplayNameRequired => 'Display name is required.';

  @override
  String get authErrorEmailAlreadyExists =>
      'An account with this email already exists.';

  @override
  String get authErrorUserNotFound => 'No account found with this email.';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrorPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get authSecurityAnswerLabel => 'Security answer';

  @override
  String get authSecurityAnswerHint => 'Used to recover your account offline';

  @override
  String get authErrorSecurityAnswerRequired => 'Security answer is required.';

  @override
  String get authErrorInvalidSecurityAnswer => 'Security answer is incorrect.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get categoryListTitle => 'Categories';

  @override
  String get categoryCreateTitle => 'Create category';

  @override
  String get categoryEditTitle => 'Edit category';

  @override
  String get categoryDashboardSubtitle =>
      'Manage income and expense categories';

  @override
  String get categorySearchPlaceholder => 'Search categories';

  @override
  String get categoryFilterAll => 'All';

  @override
  String get categoryTypeIncome => 'Income';

  @override
  String get categoryTypeExpense => 'Expense';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoryIconLabel => 'Icon';

  @override
  String get categoryColorLabel => 'Color';

  @override
  String get categoryAddAction => 'Add category';

  @override
  String get categoryCreateAction => 'Create category';

  @override
  String get categorySaveAction => 'Save changes';

  @override
  String get categoryCreateIncomeAction => 'Create income category';

  @override
  String get categoryCreateExpenseAction => 'Create expense category';

  @override
  String get categoryDeleteAction => 'Delete';

  @override
  String get categoryDeleteConfirmTitle => 'Delete category?';

  @override
  String categoryDeleteConfirmMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get categoryEmptyTitle => 'No categories yet';

  @override
  String get categoryEmptyMessage =>
      'Create income and expense categories to organize your transactions.';

  @override
  String get categoryCreateSuccess => 'Category created successfully.';

  @override
  String get categoryUpdateSuccess => 'Category updated successfully.';

  @override
  String get categoryErrorNameRequired => 'Category name is required.';

  @override
  String get categoryErrorNameTooShort =>
      'Category name must be at least 2 characters.';

  @override
  String get categoryErrorNotFound => 'Category not found.';

  @override
  String get categoryErrorDuplicateName =>
      'A category with this name already exists.';

  @override
  String get categoryErrorHasTransactions =>
      'Cannot delete a category that has transactions.';

  @override
  String get categoryErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get transactionListTitle => 'Transactions';

  @override
  String get transactionCreateTitle => 'Add transaction';

  @override
  String get transactionEditTitle => 'Edit transaction';

  @override
  String get transactionDetailTitle => 'Transaction details';

  @override
  String get transactionDashboardSubtitle => 'Track income and expenses';

  @override
  String get transactionSearchPlaceholder => 'Search transactions';

  @override
  String get transactionAmountLabel => 'Amount';

  @override
  String get transactionCategoryLabel => 'Category';

  @override
  String get transactionCategoryFilterLabel => 'Filter by category';

  @override
  String get transactionDateLabel => 'Date';

  @override
  String get transactionDateRangeLabel => 'Select date range';

  @override
  String get transactionTypeLabel => 'Type';

  @override
  String get transactionNoteLabel => 'Note';

  @override
  String get transactionAddAction => 'Add transaction';

  @override
  String get transactionCreateAction => 'Create transaction';

  @override
  String get transactionSaveAction => 'Save changes';

  @override
  String get transactionCreateIncomeAction => 'Add income';

  @override
  String get transactionCreateExpenseAction => 'Add expense';

  @override
  String get transactionDeleteAction => 'Delete';

  @override
  String get transactionClearDateRangeAction => 'Clear date range';

  @override
  String get transactionDeleteConfirmTitle => 'Delete transaction?';

  @override
  String transactionDeleteConfirmMessage(String amount) {
    return 'Are you sure you want to delete this $amount transaction?';
  }

  @override
  String get transactionEmptyTitle => 'No transactions yet';

  @override
  String get transactionEmptyMessage =>
      'Add income and expense transactions to start tracking your finances.';

  @override
  String get transactionNoCategoriesMessage =>
      'Create a matching category before adding a transaction.';

  @override
  String get transactionCreateSuccess => 'Transaction created successfully.';

  @override
  String get transactionUpdateSuccess => 'Transaction updated successfully.';

  @override
  String get transactionDeleteSuccess => 'Transaction deleted successfully.';

  @override
  String get transactionDailySummaryTitle => 'Today\'s summary';

  @override
  String get transactionMonthlySummaryTitle => 'This month\'s summary';

  @override
  String get transactionSummaryIncome => 'Income';

  @override
  String get transactionSummaryExpense => 'Expense';

  @override
  String get transactionSummaryNet => 'Net';

  @override
  String get transactionErrorAmountRequired => 'Amount is required.';

  @override
  String get transactionErrorAmountInvalid =>
      'Amount must be greater than zero.';

  @override
  String get transactionErrorCategoryRequired => 'Category is required.';

  @override
  String get transactionErrorCategoryNotFound => 'Category not found.';

  @override
  String get transactionErrorCategoryTypeMismatch =>
      'Selected category does not match the transaction type.';

  @override
  String get transactionErrorNotFound => 'Transaction not found.';

  @override
  String get transactionErrorNoteTooLong =>
      'Note must be 500 characters or fewer.';

  @override
  String get transactionErrorUnknown =>
      'Something went wrong. Please try again.';

  @override
  String get budgetListTitle => 'Budgets';

  @override
  String get budgetCreateTitle => 'Create budget';

  @override
  String get budgetEditTitle => 'Edit budget';

  @override
  String get budgetDetailTitle => 'Budget details';

  @override
  String get budgetDashboardSubtitle => 'Plan and track spending limits';

  @override
  String get budgetSearchPlaceholder => 'Search budgets';

  @override
  String get budgetNameLabel => 'Budget name';

  @override
  String get budgetAmountLabel => 'Budget amount';

  @override
  String get budgetCategoryLabel => 'Category';

  @override
  String get budgetStartDateLabel => 'Start date';

  @override
  String get budgetEndDateLabel => 'End date';

  @override
  String get budgetPeriodLabel => 'Period';

  @override
  String get budgetLimitLabel => 'Limit';

  @override
  String get budgetSpentLabel => 'Spent';

  @override
  String get budgetRemainingLabel => 'Remaining';

  @override
  String get budgetTypeOverall => 'Overall';

  @override
  String get budgetTypeCategory => 'Category';

  @override
  String get budgetStatusNormal => 'On track';

  @override
  String get budgetStatusWarning => 'Approaching limit';

  @override
  String get budgetStatusExceeded => 'Exceeded';

  @override
  String get budgetAddAction => 'Add budget';

  @override
  String get budgetCreateAction => 'Create budget';

  @override
  String get budgetSaveAction => 'Save changes';

  @override
  String get budgetCreateOverallAction => 'Create overall budget';

  @override
  String get budgetCreateCategoryAction => 'Create category budget';

  @override
  String get budgetDeleteAction => 'Delete';

  @override
  String get budgetDeleteConfirmTitle => 'Delete budget?';

  @override
  String budgetDeleteConfirmMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get budgetEmptyTitle => 'No budgets yet';

  @override
  String get budgetEmptyMessage =>
      'Create overall or category budgets to plan your spending.';

  @override
  String get budgetNoCategoriesMessage =>
      'Create an expense category before adding a category budget.';

  @override
  String get budgetCreateSuccess => 'Budget created successfully.';

  @override
  String get budgetUpdateSuccess => 'Budget updated successfully.';

  @override
  String get budgetDeleteSuccess => 'Budget deleted successfully.';

  @override
  String get budgetErrorNameRequired => 'Budget name is required.';

  @override
  String get budgetErrorNameTooShort =>
      'Budget name must be at least 2 characters.';

  @override
  String get budgetErrorAmountInvalid =>
      'Budget amount must be greater than zero.';

  @override
  String get budgetErrorDateRangeInvalid =>
      'End date must be on or after the start date.';

  @override
  String get budgetErrorCategoryRequired =>
      'Category is required for a category budget.';

  @override
  String get budgetErrorCategoryNotFound => 'Category not found.';

  @override
  String get budgetErrorCategoryTypeMismatch =>
      'Only expense categories can be used for budgets.';

  @override
  String get budgetErrorNotFound => 'Budget not found.';

  @override
  String get budgetErrorDuplicateName =>
      'A budget with this name already exists.';

  @override
  String get budgetErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get goalListTitle => 'Savings Goals';

  @override
  String get goalCreateTitle => 'Create goal';

  @override
  String get goalEditTitle => 'Edit goal';

  @override
  String get goalDetailTitle => 'Goal details';

  @override
  String get goalDashboardSubtitle => 'Track savings goals and contributions';

  @override
  String get goalSearchPlaceholder => 'Search goals';

  @override
  String get goalFilterAll => 'All';

  @override
  String get goalNameLabel => 'Goal name';

  @override
  String get goalTargetAmountLabel => 'Target amount';

  @override
  String get goalDeadlineLabel => 'Deadline';

  @override
  String get goalTargetLabel => 'Target';

  @override
  String get goalSavedLabel => 'Saved';

  @override
  String get goalRemainingLabel => 'Remaining';

  @override
  String get goalStatusActive => 'Active';

  @override
  String get goalStatusCompleted => 'Completed';

  @override
  String get goalStatusExpired => 'Expired';

  @override
  String get goalAddAction => 'Add goal';

  @override
  String get goalCreateAction => 'Create goal';

  @override
  String get goalSaveAction => 'Save changes';

  @override
  String get goalDeleteAction => 'Delete';

  @override
  String get goalAddContributionAction => 'Add contribution';

  @override
  String get goalContributionAmountLabel => 'Contribution amount';

  @override
  String get goalContributionsTitle => 'Contributions';

  @override
  String get goalDeleteConfirmTitle => 'Delete goal?';

  @override
  String goalDeleteConfirmMessage(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get goalEmptyTitle => 'No savings goals yet';

  @override
  String get goalEmptyMessage =>
      'Create a savings goal and add contributions to track your progress.';

  @override
  String get goalCreateSuccess => 'Goal created successfully.';

  @override
  String get goalUpdateSuccess => 'Goal updated successfully.';

  @override
  String get goalDeleteSuccess => 'Goal deleted successfully.';

  @override
  String get goalContributionSuccess => 'Contribution added successfully.';

  @override
  String get goalErrorNameRequired => 'Goal name is required.';

  @override
  String get goalErrorNameTooShort =>
      'Goal name must be at least 2 characters.';

  @override
  String get goalErrorTargetAmountInvalid =>
      'Target amount must be greater than zero.';

  @override
  String get goalErrorDeadlineInvalid =>
      'Deadline must be today or in the future.';

  @override
  String get goalErrorContributionAmountInvalid =>
      'Contribution amount must be greater than zero.';

  @override
  String get goalErrorNotFound => 'Goal not found.';

  @override
  String get goalErrorCompleted =>
      'Cannot add contributions to a completed goal.';

  @override
  String get goalErrorExpired => 'Cannot add contributions to an expired goal.';

  @override
  String get goalErrorDuplicateName => 'A goal with this name already exists.';

  @override
  String get goalErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get recurringListTitle => 'Recurring Transactions';

  @override
  String get recurringCreateTitle => 'Create recurring transaction';

  @override
  String get recurringEditTitle => 'Edit recurring transaction';

  @override
  String get recurringDetailTitle => 'Recurring transaction details';

  @override
  String get recurringDashboardSubtitle =>
      'Automate income and expense entries';

  @override
  String get recurringSearchPlaceholder => 'Search recurring transactions';

  @override
  String get recurringFilterAll => 'All';

  @override
  String get recurringAmountLabel => 'Amount';

  @override
  String get recurringCategoryLabel => 'Category';

  @override
  String get recurringFrequencyLabel => 'Frequency';

  @override
  String get recurringNextExecutionLabel => 'Next execution';

  @override
  String get recurringNoteLabel => 'Note';

  @override
  String get recurringFrequencyDaily => 'Daily';

  @override
  String get recurringFrequencyWeekly => 'Weekly';

  @override
  String get recurringFrequencyMonthly => 'Monthly';

  @override
  String get recurringFrequencyYearly => 'Yearly';

  @override
  String get recurringStatusActive => 'Active';

  @override
  String get recurringStatusPaused => 'Paused';

  @override
  String get recurringAddAction => 'Add recurring';

  @override
  String get recurringCreateAction => 'Create recurring';

  @override
  String get recurringSaveAction => 'Save changes';

  @override
  String get recurringDeleteAction => 'Delete';

  @override
  String get recurringPauseAction => 'Pause';

  @override
  String get recurringResumeAction => 'Resume';

  @override
  String get recurringDeleteConfirmTitle => 'Delete recurring transaction?';

  @override
  String recurringDeleteConfirmMessage(String name) {
    return 'Are you sure you want to delete the recurring transaction for \"$name\"?';
  }

  @override
  String get recurringEmptyTitle => 'No recurring transactions yet';

  @override
  String get recurringEmptyMessage =>
      'Create a recurring transaction to automate your income and expenses.';

  @override
  String get recurringNoCategoriesMessage =>
      'Create a category before adding a recurring transaction.';

  @override
  String get recurringCreateSuccess =>
      'Recurring transaction created successfully.';

  @override
  String get recurringUpdateSuccess =>
      'Recurring transaction updated successfully.';

  @override
  String get recurringDeleteSuccess =>
      'Recurring transaction deleted successfully.';

  @override
  String get recurringPauseSuccess =>
      'Recurring transaction paused successfully.';

  @override
  String get recurringResumeSuccess =>
      'Recurring transaction resumed successfully.';

  @override
  String get recurringErrorAmountInvalid => 'Amount must be greater than zero.';

  @override
  String get recurringErrorCategoryRequired => 'Category is required.';

  @override
  String get recurringErrorCategoryNotFound => 'Category not found.';

  @override
  String get recurringErrorCategoryTypeMismatch =>
      'Category type does not match transaction type.';

  @override
  String get recurringErrorNoteTooLong =>
      'Note must be 500 characters or fewer.';

  @override
  String get recurringErrorNextExecutionInvalid =>
      'Next execution date must be today or in the future.';

  @override
  String get recurringErrorNotFound => 'Recurring transaction not found.';

  @override
  String get recurringErrorUnknown => 'Something went wrong. Please try again.';
}
