import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Personal Finance Manager'**
  String get appTitle;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Dashboard total income metric label
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get dashboardTotalIncomeLabel;

  /// Dashboard total expense metric label
  ///
  /// In en, this message translates to:
  /// **'Total expense'**
  String get dashboardTotalExpenseLabel;

  /// Dashboard total savings metric label
  ///
  /// In en, this message translates to:
  /// **'Total savings'**
  String get dashboardTotalSavingsLabel;

  /// Dashboard net balance metric label
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get dashboardNetBalanceLabel;

  /// Dashboard budget usage section title
  ///
  /// In en, this message translates to:
  /// **'Budget usage'**
  String get dashboardBudgetUsageTitle;

  /// Dashboard active goals section title
  ///
  /// In en, this message translates to:
  /// **'Active goals ({count})'**
  String dashboardActiveGoalsTitle(int count);

  /// Dashboard income vs expense chart title
  ///
  /// In en, this message translates to:
  /// **'Income vs expense'**
  String get dashboardIncomeExpenseChartTitle;

  /// Dashboard monthly trend chart title
  ///
  /// In en, this message translates to:
  /// **'Monthly trend'**
  String get dashboardMonthlyTrendChartTitle;

  /// Dashboard category distribution chart title
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get dashboardCategoryChartTitle;

  /// Dashboard chart empty state message
  ///
  /// In en, this message translates to:
  /// **'No data for the selected period.'**
  String get dashboardChartEmptyMessage;

  /// Dashboard quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActionsTitle;

  /// Dashboard quick action to add transaction
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get dashboardQuickAddTransaction;

  /// Dashboard quick action to add budget
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get dashboardQuickAddBudget;

  /// Dashboard quick action to add goal
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get dashboardQuickAddGoal;

  /// Dashboard quick action to view transactions
  ///
  /// In en, this message translates to:
  /// **'View transactions'**
  String get dashboardQuickViewTransactions;

  /// Dashboard date range filter this month
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashboardRangeThisMonth;

  /// Dashboard date range filter last month
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get dashboardRangeLastMonth;

  /// Dashboard date range filter last three months
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get dashboardRangeLastThreeMonths;

  /// Dashboard date range filter last six months
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get dashboardRangeLastSixMonths;

  /// Dashboard date range filter this year
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get dashboardRangeThisYear;

  /// Dashboard refresh action
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardRefreshAction;

  /// Dashboard view all action
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAllAction;

  /// Dashboard empty state title
  ///
  /// In en, this message translates to:
  /// **'Your dashboard is empty'**
  String get dashboardEmptyTitle;

  /// Dashboard empty state message
  ///
  /// In en, this message translates to:
  /// **'Add transactions, budgets, or goals to see your financial overview.'**
  String get dashboardEmptyMessage;

  /// Dashboard empty state when selected date range has no data
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get dashboardRangeEmptyTitle;

  /// Dashboard empty state message when date range has no data
  ///
  /// In en, this message translates to:
  /// **'Try a different date range or add transactions for this period.'**
  String get dashboardRangeEmptyMessage;

  /// Unknown dashboard error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get dashboardErrorUnknown;

  /// Reports list screen title
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportListTitle;

  /// Monthly report type label
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get reportTypeMonthly;

  /// Yearly report type label
  ///
  /// In en, this message translates to:
  /// **'Yearly Report'**
  String get reportTypeYearly;

  /// Category report type label
  ///
  /// In en, this message translates to:
  /// **'Category Report'**
  String get reportTypeCategory;

  /// Budget analysis report type label
  ///
  /// In en, this message translates to:
  /// **'Budget Analysis'**
  String get reportTypeBudget;

  /// Goal progress report type label
  ///
  /// In en, this message translates to:
  /// **'Goal Progress'**
  String get reportTypeGoal;

  /// Monthly report type description
  ///
  /// In en, this message translates to:
  /// **'Income, expenses, and trends for a selected month.'**
  String get reportTypeMonthlyDescription;

  /// Yearly report type description
  ///
  /// In en, this message translates to:
  /// **'Annual overview with monthly breakdown.'**
  String get reportTypeYearlyDescription;

  /// Category report type description
  ///
  /// In en, this message translates to:
  /// **'Spending breakdown by expense category.'**
  String get reportTypeCategoryDescription;

  /// Budget analysis report type description
  ///
  /// In en, this message translates to:
  /// **'Budget usage, warnings, and exceeded limits.'**
  String get reportTypeBudgetDescription;

  /// Goal progress report type description
  ///
  /// In en, this message translates to:
  /// **'Savings goals progress and completion status.'**
  String get reportTypeGoalDescription;

  /// Report date range preset
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get reportRangeThisMonth;

  /// Report date range preset
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get reportRangeLastMonth;

  /// Report date range preset
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get reportRangeLastThreeMonths;

  /// Report date range preset
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get reportRangeLastSixMonths;

  /// Report date range preset
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get reportRangeThisYear;

  /// Report summary metric
  ///
  /// In en, this message translates to:
  /// **'Total income'**
  String get reportTotalIncomeLabel;

  /// Report summary metric
  ///
  /// In en, this message translates to:
  /// **'Total expense'**
  String get reportTotalExpenseLabel;

  /// Report summary metric
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get reportNetBalanceLabel;

  /// Report summary metric
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get reportTransactionCountLabel;

  /// Report summary metric for goals
  ///
  /// In en, this message translates to:
  /// **'Total savings'**
  String get reportTotalSavingsLabel;

  /// Report summary metric for budgets
  ///
  /// In en, this message translates to:
  /// **'Total budgets'**
  String get reportTotalBudgetsLabel;

  /// Report summary metric for budgets
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get reportTotalSpentLabel;

  /// Report exceeded budgets count
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get reportExceededBudgetsLabel;

  /// Report warning budgets count
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get reportWarningBudgetsLabel;

  /// Report active goals count
  ///
  /// In en, this message translates to:
  /// **'Active goals'**
  String get reportActiveGoalsLabel;

  /// Report completed goals count
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get reportCompletedGoalsLabel;

  /// Report budget section title
  ///
  /// In en, this message translates to:
  /// **'Budget usage'**
  String get reportBudgetSectionTitle;

  /// Report goal section title
  ///
  /// In en, this message translates to:
  /// **'Goal progress'**
  String get reportGoalSectionTitle;

  /// Report empty state title
  ///
  /// In en, this message translates to:
  /// **'No report data'**
  String get reportEmptyTitle;

  /// Report empty state message
  ///
  /// In en, this message translates to:
  /// **'Adjust filters or add data to generate this report.'**
  String get reportEmptyMessage;

  /// Unknown report error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get reportErrorUnknown;

  /// Report refresh action
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get reportRefreshAction;

  /// Export screen title
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportTitle;

  /// Export screen description
  ///
  /// In en, this message translates to:
  /// **'Export your financial data as PDF or CSV files. Files are saved locally and can be shared.'**
  String get exportDescription;

  /// Export data type label
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get exportDataTypeTransactions;

  /// Export data type label
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get exportDataTypeBudgets;

  /// Export data type label
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get exportDataTypeGoals;

  /// Export data type label
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get exportDataTypeReports;

  /// Export data type description
  ///
  /// In en, this message translates to:
  /// **'Export all transactions with summary and charts.'**
  String get exportDataTypeTransactionsDescription;

  /// Export data type description
  ///
  /// In en, this message translates to:
  /// **'Export budgets with usage and status.'**
  String get exportDataTypeBudgetsDescription;

  /// Export data type description
  ///
  /// In en, this message translates to:
  /// **'Export savings goals with progress.'**
  String get exportDataTypeGoalsDescription;

  /// Export data type description
  ///
  /// In en, this message translates to:
  /// **'Export all financial reports.'**
  String get exportDataTypeReportsDescription;

  /// PDF export format label
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportFormatPdf;

  /// CSV export format label
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportFormatCsv;

  /// Toggle date filter for export
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get exportUseDateFilterLabel;

  /// Export summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get exportSummaryTitle;

  /// Export generated timestamp label
  ///
  /// In en, this message translates to:
  /// **'Generated at'**
  String get exportGeneratedAtLabel;

  /// Export date range label
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get exportDateRangeLabel;

  /// Export all dates label
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get exportAllDatesLabel;

  /// Export income label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get exportIncomeLabel;

  /// Export expense label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get exportExpenseLabel;

  /// Export net balance label
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get exportNetBalanceLabel;

  /// Export transaction count label
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get exportTransactionCountLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get exportIdLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get exportTypeLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get exportAmountLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get exportDateLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get exportNoteLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exportCategoryLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exportNameLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get exportTargetLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get exportCurrentLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get exportDeadlineLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get exportStatusLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get exportSpentLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get exportRemainingLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get exportUsageLabel;

  /// Export column label
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get exportCompletionLabel;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Saved {fileName}'**
  String exportSuccessMessage(String fileName);

  /// Export share dialog title
  ///
  /// In en, this message translates to:
  /// **'Share export?'**
  String get exportShareTitle;

  /// Export share dialog message
  ///
  /// In en, this message translates to:
  /// **'Your file was saved locally. Would you like to share it now?'**
  String get exportShareMessage;

  /// Export share action
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get exportShareAction;

  /// Export share dismiss action
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get exportShareDismissAction;

  /// Unknown export error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get exportErrorUnknown;

  /// Export no data error
  ///
  /// In en, this message translates to:
  /// **'No data available to export.'**
  String get exportErrorNoData;

  /// Export file write error
  ///
  /// In en, this message translates to:
  /// **'Failed to save the export file.'**
  String get exportErrorFileWrite;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// Currency selection label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrencyLabel;

  /// US Dollar currency label
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get settingsCurrencyUsd;

  /// Euro currency label
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get settingsCurrencyEur;

  /// British Pound currency label
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get settingsCurrencyGbp;

  /// Indian Rupee currency label
  ///
  /// In en, this message translates to:
  /// **'Indian Rupee'**
  String get settingsCurrencyInr;

  /// Japanese Yen currency label
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get settingsCurrencyJpy;

  /// Canadian Dollar currency label
  ///
  /// In en, this message translates to:
  /// **'Canadian Dollar'**
  String get settingsCurrencyCad;

  /// Australian Dollar currency label
  ///
  /// In en, this message translates to:
  /// **'Australian Dollar'**
  String get settingsCurrencyAud;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// Notification preferences section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// Notification preferences section subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose which reminders you want to receive'**
  String get settingsNotificationsSubtitle;

  /// Budget warning notification preference
  ///
  /// In en, this message translates to:
  /// **'Budget approaching limit'**
  String get settingsNotificationBudgetWarning;

  /// Budget exceeded notification preference
  ///
  /// In en, this message translates to:
  /// **'Budget exceeded'**
  String get settingsNotificationBudgetExceeded;

  /// Goal reminder notification preference
  ///
  /// In en, this message translates to:
  /// **'Goal contribution reminder'**
  String get settingsNotificationGoalReminder;

  /// Goal deadline notification preference
  ///
  /// In en, this message translates to:
  /// **'Goal deadline reminder'**
  String get settingsNotificationGoalDeadline;

  /// Recurring transaction notification preference
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction reminder'**
  String get settingsNotificationRecurringReminder;

  /// Monthly summary notification preference
  ///
  /// In en, this message translates to:
  /// **'Monthly summary reminder'**
  String get settingsNotificationMonthlySummary;

  /// Export preferences section title
  ///
  /// In en, this message translates to:
  /// **'Export defaults'**
  String get settingsExportPreferencesTitle;

  /// Export preferences section subtitle
  ///
  /// In en, this message translates to:
  /// **'Default options used on the export screen'**
  String get settingsExportPreferencesSubtitle;

  /// Export date filter default toggle
  ///
  /// In en, this message translates to:
  /// **'Use date range filter by default'**
  String get settingsExportUseDateFilter;

  /// Account section title in settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// Delete account button label
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccountButton;

  /// Delete account confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settingsDeleteAccountConfirmTitle;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all financial data on this device. This action cannot be undone.'**
  String get settingsDeleteAccountConfirmMessage;

  /// Unknown settings error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get settingsErrorUnknown;

  /// Delete account failure error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settingsErrorDeleteAccountFailed;

  /// Authentication screen title
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authTitle;

  /// Display name for the English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Default confirm button label for dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get widgetActionConfirm;

  /// Default cancel button label for dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get widgetActionCancel;

  /// Default close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get widgetActionClose;

  /// Default retry button label for error states
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get widgetActionRetry;

  /// Default placeholder for search fields
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get widgetSearchPlaceholder;

  /// Accessibility label for loading indicators
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get widgetLoading;

  /// Default title for error states
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get widgetErrorTitle;

  /// Default message for error states
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get widgetErrorMessage;

  /// Default title for empty states
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get widgetEmptyTitle;

  /// Default message for empty states
  ///
  /// In en, this message translates to:
  /// **'There is no content to display.'**
  String get widgetEmptyMessage;

  /// Accessibility label for previous page button
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get widgetPreviousPage;

  /// Accessibility label for next page button
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get widgetNextPage;

  /// Page indicator for pagination
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String widgetPageIndicator(int current, int total);

  /// Error message when an image fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get widgetImageLoadError;

  /// Default title for confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm action'**
  String get widgetConfirmationTitle;

  /// Default message for confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to continue?'**
  String get widgetConfirmationMessage;

  /// Accessibility label for dismissing a snackbar
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get widgetDismiss;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your personal finances'**
  String get authLoginSubtitle;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Set up your offline finance profile'**
  String get authRegisterSubtitle;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authForgotPasswordTitle;

  /// Forgot password screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your email and choose a new password'**
  String get authForgotPasswordSubtitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayNameLabel;

  /// Login button label
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// Register button label
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authRegisterButton;

  /// Reset password button label
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordButton;

  /// Link to forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordLink;

  /// Link to register screen
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterLink;

  /// Link to login screen
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginLink;

  /// Link back to login screen
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToLoginLink;

  /// Prompt before register link on login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccountPrompt;

  /// Prompt before login link on register screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccountPrompt;

  /// Snackbar message after password reset
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please sign in.'**
  String get authPasswordResetSuccess;

  /// Sign out button label
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOutButton;

  /// Invalid email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// Weak password validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get authErrorWeakPassword;

  /// Display name required validation error
  ///
  /// In en, this message translates to:
  /// **'Display name is required.'**
  String get authErrorDisplayNameRequired;

  /// Email already registered error
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get authErrorEmailAlreadyExists;

  /// User not found error
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get authErrorUserNotFound;

  /// Invalid login credentials error
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredentials;

  /// Password confirmation mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authErrorPasswordsDoNotMatch;

  /// Security answer field label for account recovery
  ///
  /// In en, this message translates to:
  /// **'Security answer'**
  String get authSecurityAnswerLabel;

  /// Helper text for security answer field
  ///
  /// In en, this message translates to:
  /// **'Used to recover your account offline'**
  String get authSecurityAnswerHint;

  /// Security answer required validation error
  ///
  /// In en, this message translates to:
  /// **'Security answer is required.'**
  String get authErrorSecurityAnswerRequired;

  /// Invalid security answer error
  ///
  /// In en, this message translates to:
  /// **'Security answer is incorrect.'**
  String get authErrorInvalidSecurityAnswer;

  /// Unknown authentication error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// Category list screen title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoryListTitle;

  /// Create category screen title
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get categoryCreateTitle;

  /// Edit category screen title
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoryEditTitle;

  /// Dashboard card subtitle for categories
  ///
  /// In en, this message translates to:
  /// **'Manage income and expense categories'**
  String get categoryDashboardSubtitle;

  /// Category search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get categorySearchPlaceholder;

  /// Show all category types filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryFilterAll;

  /// Income category type label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryTypeIncome;

  /// Expense category type label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get categoryTypeExpense;

  /// Category name field label
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// Category icon picker label
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get categoryIconLabel;

  /// Category color picker label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get categoryColorLabel;

  /// Add category action label
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get categoryAddAction;

  /// Create category submit button
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get categoryCreateAction;

  /// Save category changes button
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get categorySaveAction;

  /// Create income category action
  ///
  /// In en, this message translates to:
  /// **'Create income category'**
  String get categoryCreateIncomeAction;

  /// Create expense category action
  ///
  /// In en, this message translates to:
  /// **'Create expense category'**
  String get categoryCreateExpenseAction;

  /// Delete category action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get categoryDeleteAction;

  /// Delete category confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get categoryDeleteConfirmTitle;

  /// Delete category confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String categoryDeleteConfirmMessage(String name);

  /// Empty category list title
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoryEmptyTitle;

  /// Empty category list message
  ///
  /// In en, this message translates to:
  /// **'Create income and expense categories to organize your transactions.'**
  String get categoryEmptyMessage;

  /// Category created success message
  ///
  /// In en, this message translates to:
  /// **'Category created successfully.'**
  String get categoryCreateSuccess;

  /// Category updated success message
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully.'**
  String get categoryUpdateSuccess;

  /// Category name required error
  ///
  /// In en, this message translates to:
  /// **'Category name is required.'**
  String get categoryErrorNameRequired;

  /// Category name too short error
  ///
  /// In en, this message translates to:
  /// **'Category name must be at least 2 characters.'**
  String get categoryErrorNameTooShort;

  /// Category not found error
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get categoryErrorNotFound;

  /// Duplicate category name error
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exists.'**
  String get categoryErrorDuplicateName;

  /// Category has transactions error
  ///
  /// In en, this message translates to:
  /// **'Cannot delete a category that has transactions.'**
  String get categoryErrorHasTransactions;

  /// Unknown category error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get categoryErrorUnknown;

  /// Transaction list screen title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionListTitle;

  /// Create transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get transactionCreateTitle;

  /// Edit transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get transactionEditTitle;

  /// Transaction detail screen title
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get transactionDetailTitle;

  /// Dashboard card subtitle for transactions
  ///
  /// In en, this message translates to:
  /// **'Track income and expenses'**
  String get transactionDashboardSubtitle;

  /// Transaction search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get transactionSearchPlaceholder;

  /// Transaction amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmountLabel;

  /// Transaction category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCategoryLabel;

  /// Transaction category filter label
  ///
  /// In en, this message translates to:
  /// **'Filter by category'**
  String get transactionCategoryFilterLabel;

  /// Transaction date field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDateLabel;

  /// Transaction date range filter label
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get transactionDateRangeLabel;

  /// Transaction type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionTypeLabel;

  /// Transaction note field label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get transactionNoteLabel;

  /// Add transaction action label
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get transactionAddAction;

  /// Create transaction submit button
  ///
  /// In en, this message translates to:
  /// **'Create transaction'**
  String get transactionCreateAction;

  /// Save transaction changes button
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get transactionSaveAction;

  /// Add income transaction action
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get transactionCreateIncomeAction;

  /// Add expense transaction action
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get transactionCreateExpenseAction;

  /// Delete transaction action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get transactionDeleteAction;

  /// Clear date range filter action
  ///
  /// In en, this message translates to:
  /// **'Clear date range'**
  String get transactionClearDateRangeAction;

  /// Delete transaction confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get transactionDeleteConfirmTitle;

  /// Delete transaction confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this {amount} transaction?'**
  String transactionDeleteConfirmMessage(String amount);

  /// Empty transaction list title
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get transactionEmptyTitle;

  /// Empty transaction list message
  ///
  /// In en, this message translates to:
  /// **'Add income and expense transactions to start tracking your finances.'**
  String get transactionEmptyMessage;

  /// Message when no categories exist for transaction type
  ///
  /// In en, this message translates to:
  /// **'Create a matching category before adding a transaction.'**
  String get transactionNoCategoriesMessage;

  /// Transaction created success message
  ///
  /// In en, this message translates to:
  /// **'Transaction created successfully.'**
  String get transactionCreateSuccess;

  /// Transaction updated success message
  ///
  /// In en, this message translates to:
  /// **'Transaction updated successfully.'**
  String get transactionUpdateSuccess;

  /// Transaction deleted success message
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted successfully.'**
  String get transactionDeleteSuccess;

  /// Daily transaction summary title
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get transactionDailySummaryTitle;

  /// Monthly transaction summary title
  ///
  /// In en, this message translates to:
  /// **'This month\'s summary'**
  String get transactionMonthlySummaryTitle;

  /// Income label in transaction summary
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionSummaryIncome;

  /// Expense label in transaction summary
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionSummaryExpense;

  /// Net label in transaction summary
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get transactionSummaryNet;

  /// Transaction amount required error
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get transactionErrorAmountRequired;

  /// Transaction amount invalid error
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get transactionErrorAmountInvalid;

  /// Transaction category required error
  ///
  /// In en, this message translates to:
  /// **'Category is required.'**
  String get transactionErrorCategoryRequired;

  /// Transaction category not found error
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get transactionErrorCategoryNotFound;

  /// Transaction category type mismatch error
  ///
  /// In en, this message translates to:
  /// **'Selected category does not match the transaction type.'**
  String get transactionErrorCategoryTypeMismatch;

  /// Transaction not found error
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get transactionErrorNotFound;

  /// Transaction note too long error
  ///
  /// In en, this message translates to:
  /// **'Note must be 500 characters or fewer.'**
  String get transactionErrorNoteTooLong;

  /// Unknown transaction error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get transactionErrorUnknown;

  /// Budget list screen title
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetListTitle;

  /// Create budget screen title
  ///
  /// In en, this message translates to:
  /// **'Create budget'**
  String get budgetCreateTitle;

  /// Edit budget screen title
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get budgetEditTitle;

  /// Budget detail screen title
  ///
  /// In en, this message translates to:
  /// **'Budget details'**
  String get budgetDetailTitle;

  /// Dashboard card subtitle for budgets
  ///
  /// In en, this message translates to:
  /// **'Plan and track spending limits'**
  String get budgetDashboardSubtitle;

  /// Budget search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search budgets'**
  String get budgetSearchPlaceholder;

  /// Budget name field label
  ///
  /// In en, this message translates to:
  /// **'Budget name'**
  String get budgetNameLabel;

  /// Budget amount field label
  ///
  /// In en, this message translates to:
  /// **'Budget amount'**
  String get budgetAmountLabel;

  /// Budget category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get budgetCategoryLabel;

  /// Budget start date label
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get budgetStartDateLabel;

  /// Budget end date label
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get budgetEndDateLabel;

  /// Budget period label
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get budgetPeriodLabel;

  /// Budget limit label
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get budgetLimitLabel;

  /// Budget spent label
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get budgetSpentLabel;

  /// Budget remaining label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budgetRemainingLabel;

  /// Overall budget type label
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get budgetTypeOverall;

  /// Category budget type label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get budgetTypeCategory;

  /// Budget normal status label
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get budgetStatusNormal;

  /// Budget warning status label at 80 percent
  ///
  /// In en, this message translates to:
  /// **'Approaching limit'**
  String get budgetStatusWarning;

  /// Budget exceeded status label at 100 percent
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get budgetStatusExceeded;

  /// Add budget action label
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get budgetAddAction;

  /// Create budget submit button
  ///
  /// In en, this message translates to:
  /// **'Create budget'**
  String get budgetCreateAction;

  /// Save budget changes button
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get budgetSaveAction;

  /// Create overall budget action
  ///
  /// In en, this message translates to:
  /// **'Create overall budget'**
  String get budgetCreateOverallAction;

  /// Create category budget action
  ///
  /// In en, this message translates to:
  /// **'Create category budget'**
  String get budgetCreateCategoryAction;

  /// Delete budget action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get budgetDeleteAction;

  /// Delete budget confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete budget?'**
  String get budgetDeleteConfirmTitle;

  /// Delete budget confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String budgetDeleteConfirmMessage(String name);

  /// Empty budget list title
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get budgetEmptyTitle;

  /// Empty budget list message
  ///
  /// In en, this message translates to:
  /// **'Create overall or category budgets to plan your spending.'**
  String get budgetEmptyMessage;

  /// Message when no expense categories exist
  ///
  /// In en, this message translates to:
  /// **'Create an expense category before adding a category budget.'**
  String get budgetNoCategoriesMessage;

  /// Budget created success message
  ///
  /// In en, this message translates to:
  /// **'Budget created successfully.'**
  String get budgetCreateSuccess;

  /// Budget updated success message
  ///
  /// In en, this message translates to:
  /// **'Budget updated successfully.'**
  String get budgetUpdateSuccess;

  /// Budget deleted success message
  ///
  /// In en, this message translates to:
  /// **'Budget deleted successfully.'**
  String get budgetDeleteSuccess;

  /// Budget name required error
  ///
  /// In en, this message translates to:
  /// **'Budget name is required.'**
  String get budgetErrorNameRequired;

  /// Budget name too short error
  ///
  /// In en, this message translates to:
  /// **'Budget name must be at least 2 characters.'**
  String get budgetErrorNameTooShort;

  /// Budget amount invalid error
  ///
  /// In en, this message translates to:
  /// **'Budget amount must be greater than zero.'**
  String get budgetErrorAmountInvalid;

  /// Budget date range invalid error
  ///
  /// In en, this message translates to:
  /// **'End date must be on or after the start date.'**
  String get budgetErrorDateRangeInvalid;

  /// Budget category required error
  ///
  /// In en, this message translates to:
  /// **'Category is required for a category budget.'**
  String get budgetErrorCategoryRequired;

  /// Budget category not found error
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get budgetErrorCategoryNotFound;

  /// Budget category type mismatch error
  ///
  /// In en, this message translates to:
  /// **'Only expense categories can be used for budgets.'**
  String get budgetErrorCategoryTypeMismatch;

  /// Budget not found error
  ///
  /// In en, this message translates to:
  /// **'Budget not found.'**
  String get budgetErrorNotFound;

  /// Duplicate budget name error
  ///
  /// In en, this message translates to:
  /// **'A budget with this name already exists.'**
  String get budgetErrorDuplicateName;

  /// Unknown budget error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get budgetErrorUnknown;

  /// Goal list screen title
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get goalListTitle;

  /// Create goal screen title
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get goalCreateTitle;

  /// Edit goal screen title
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get goalEditTitle;

  /// Goal detail screen title
  ///
  /// In en, this message translates to:
  /// **'Goal details'**
  String get goalDetailTitle;

  /// Dashboard card subtitle for goals
  ///
  /// In en, this message translates to:
  /// **'Track savings goals and contributions'**
  String get goalDashboardSubtitle;

  /// Goal search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search goals'**
  String get goalSearchPlaceholder;

  /// Show all goal statuses filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get goalFilterAll;

  /// Goal name field label
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalNameLabel;

  /// Goal target amount field label
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalTargetAmountLabel;

  /// Goal deadline label
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get goalDeadlineLabel;

  /// Goal target label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get goalTargetLabel;

  /// Goal saved amount label
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get goalSavedLabel;

  /// Goal remaining amount label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get goalRemainingLabel;

  /// Active goal status label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get goalStatusActive;

  /// Completed goal status label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalStatusCompleted;

  /// Expired goal status label
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get goalStatusExpired;

  /// Add goal action label
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get goalAddAction;

  /// Create goal submit button
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get goalCreateAction;

  /// Save goal changes button
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get goalSaveAction;

  /// Delete goal action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get goalDeleteAction;

  /// Add contribution action
  ///
  /// In en, this message translates to:
  /// **'Add contribution'**
  String get goalAddContributionAction;

  /// Contribution amount field label
  ///
  /// In en, this message translates to:
  /// **'Contribution amount'**
  String get goalContributionAmountLabel;

  /// Contributions section title
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get goalContributionsTitle;

  /// Delete goal confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete goal?'**
  String get goalDeleteConfirmTitle;

  /// Delete goal confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String goalDeleteConfirmMessage(String name);

  /// Empty goal list title
  ///
  /// In en, this message translates to:
  /// **'No savings goals yet'**
  String get goalEmptyTitle;

  /// Empty goal list message
  ///
  /// In en, this message translates to:
  /// **'Create a savings goal and add contributions to track your progress.'**
  String get goalEmptyMessage;

  /// Goal created success message
  ///
  /// In en, this message translates to:
  /// **'Goal created successfully.'**
  String get goalCreateSuccess;

  /// Goal updated success message
  ///
  /// In en, this message translates to:
  /// **'Goal updated successfully.'**
  String get goalUpdateSuccess;

  /// Goal deleted success message
  ///
  /// In en, this message translates to:
  /// **'Goal deleted successfully.'**
  String get goalDeleteSuccess;

  /// Contribution added success message
  ///
  /// In en, this message translates to:
  /// **'Contribution added successfully.'**
  String get goalContributionSuccess;

  /// Goal name required error
  ///
  /// In en, this message translates to:
  /// **'Goal name is required.'**
  String get goalErrorNameRequired;

  /// Goal name too short error
  ///
  /// In en, this message translates to:
  /// **'Goal name must be at least 2 characters.'**
  String get goalErrorNameTooShort;

  /// Goal target amount invalid error
  ///
  /// In en, this message translates to:
  /// **'Target amount must be greater than zero.'**
  String get goalErrorTargetAmountInvalid;

  /// Goal deadline invalid error
  ///
  /// In en, this message translates to:
  /// **'Deadline must be today or in the future.'**
  String get goalErrorDeadlineInvalid;

  /// Contribution amount invalid error
  ///
  /// In en, this message translates to:
  /// **'Contribution amount must be greater than zero.'**
  String get goalErrorContributionAmountInvalid;

  /// Goal not found error
  ///
  /// In en, this message translates to:
  /// **'Goal not found.'**
  String get goalErrorNotFound;

  /// Goal already completed error
  ///
  /// In en, this message translates to:
  /// **'Cannot add contributions to a completed goal.'**
  String get goalErrorCompleted;

  /// Goal expired error
  ///
  /// In en, this message translates to:
  /// **'Cannot add contributions to an expired goal.'**
  String get goalErrorExpired;

  /// Duplicate goal name error
  ///
  /// In en, this message translates to:
  /// **'A goal with this name already exists.'**
  String get goalErrorDuplicateName;

  /// Unknown goal error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get goalErrorUnknown;

  /// Recurring transaction list screen title
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get recurringListTitle;

  /// Create recurring transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Create recurring transaction'**
  String get recurringCreateTitle;

  /// Edit recurring transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Edit recurring transaction'**
  String get recurringEditTitle;

  /// Recurring transaction detail screen title
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction details'**
  String get recurringDetailTitle;

  /// Dashboard card subtitle for recurring transactions
  ///
  /// In en, this message translates to:
  /// **'Automate income and expense entries'**
  String get recurringDashboardSubtitle;

  /// Recurring transaction search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search recurring transactions'**
  String get recurringSearchPlaceholder;

  /// Show all recurring transaction statuses filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get recurringFilterAll;

  /// Recurring transaction amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringAmountLabel;

  /// Recurring transaction category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get recurringCategoryLabel;

  /// Recurring transaction frequency label
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get recurringFrequencyLabel;

  /// Next execution date label
  ///
  /// In en, this message translates to:
  /// **'Next execution'**
  String get recurringNextExecutionLabel;

  /// Recurring transaction note field label
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get recurringNoteLabel;

  /// Daily recurrence label
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurringFrequencyDaily;

  /// Weekly recurrence label
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringFrequencyWeekly;

  /// Monthly recurrence label
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringFrequencyMonthly;

  /// Yearly recurrence label
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurringFrequencyYearly;

  /// Active recurring transaction status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get recurringStatusActive;

  /// Paused recurring transaction status
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get recurringStatusPaused;

  /// Add recurring transaction action
  ///
  /// In en, this message translates to:
  /// **'Add recurring'**
  String get recurringAddAction;

  /// Create recurring transaction submit button
  ///
  /// In en, this message translates to:
  /// **'Create recurring'**
  String get recurringCreateAction;

  /// Save recurring transaction changes button
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get recurringSaveAction;

  /// Delete recurring transaction action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recurringDeleteAction;

  /// Pause recurring transaction action
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get recurringPauseAction;

  /// Resume recurring transaction action
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get recurringResumeAction;

  /// Delete recurring transaction confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete recurring transaction?'**
  String get recurringDeleteConfirmTitle;

  /// Delete recurring transaction confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the recurring transaction for \"{name}\"?'**
  String recurringDeleteConfirmMessage(String name);

  /// Empty recurring transaction list title
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions yet'**
  String get recurringEmptyTitle;

  /// Empty recurring transaction list message
  ///
  /// In en, this message translates to:
  /// **'Create a recurring transaction to automate your income and expenses.'**
  String get recurringEmptyMessage;

  /// Message when no categories exist for recurring form
  ///
  /// In en, this message translates to:
  /// **'Create a category before adding a recurring transaction.'**
  String get recurringNoCategoriesMessage;

  /// Recurring transaction created success message
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction created successfully.'**
  String get recurringCreateSuccess;

  /// Recurring transaction updated success message
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction updated successfully.'**
  String get recurringUpdateSuccess;

  /// Recurring transaction deleted success message
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction deleted successfully.'**
  String get recurringDeleteSuccess;

  /// Recurring transaction paused success message
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction paused successfully.'**
  String get recurringPauseSuccess;

  /// Recurring transaction resumed success message
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction resumed successfully.'**
  String get recurringResumeSuccess;

  /// Recurring transaction amount invalid error
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get recurringErrorAmountInvalid;

  /// Recurring transaction category required error
  ///
  /// In en, this message translates to:
  /// **'Category is required.'**
  String get recurringErrorCategoryRequired;

  /// Recurring transaction category not found error
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get recurringErrorCategoryNotFound;

  /// Recurring transaction category type mismatch error
  ///
  /// In en, this message translates to:
  /// **'Category type does not match transaction type.'**
  String get recurringErrorCategoryTypeMismatch;

  /// Recurring transaction note too long error
  ///
  /// In en, this message translates to:
  /// **'Note must be 500 characters or fewer.'**
  String get recurringErrorNoteTooLong;

  /// Recurring transaction next execution invalid error
  ///
  /// In en, this message translates to:
  /// **'Next execution date must be today or in the future.'**
  String get recurringErrorNextExecutionInvalid;

  /// Recurring transaction not found error
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction not found.'**
  String get recurringErrorNotFound;

  /// Unknown recurring transaction error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get recurringErrorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
