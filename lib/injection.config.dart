// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/currency/currency_cubit.dart' as _i231;
import 'core/database/app_database.dart' as _i111;
import 'core/di/database_module.dart' as _i878;
import 'core/di/storage_module.dart' as _i540;
import 'core/l10n/locale_cubit.dart' as _i885;
import 'core/l10n/locale_service.dart' as _i56;
import 'core/l10n/locale_storage.dart' as _i646;
import 'core/l10n/locale_storage_impl.dart' as _i26;
import 'core/services/password_hasher.dart' as _i59;
import 'core/theme/theme_cubit.dart' as _i463;
import 'features/auth/data/datasource/auth_local_datasource.dart' as _i246;
import 'features/auth/data/repository_impl/auth_repository_impl.dart' as _i132;
import 'features/auth/domain/repository/auth_repository.dart' as _i279;
import 'features/auth/domain/usecases/auth_usecases.dart' as _i536;
import 'features/auth/presentation/bloc/auth/auth_bloc.dart' as _i339;
import 'features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart'
    as _i175;
import 'features/auth/presentation/bloc/login/login_bloc.dart' as _i555;
import 'features/auth/presentation/bloc/register/register_bloc.dart' as _i649;
import 'features/budgets/data/datasource/budget_local_datasource.dart' as _i898;
import 'features/budgets/data/repository_impl/budget_repository_impl.dart'
    as _i15;
import 'features/budgets/domain/repository/budget_repository.dart' as _i841;
import 'features/budgets/domain/usecases/budget_usecases.dart' as _i747;
import 'features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart'
    as _i558;
import 'features/budgets/presentation/bloc/budget_form/budget_form_bloc.dart'
    as _i502;
import 'features/budgets/presentation/bloc/budget_list/budget_list_bloc.dart'
    as _i735;
import 'features/categories/data/datasource/category_local_datasource.dart'
    as _i71;
import 'features/categories/data/repository_impl/category_repository_impl.dart'
    as _i851;
import 'features/categories/domain/repository/category_repository.dart'
    as _i976;
import 'features/categories/domain/usecases/category_usecases.dart' as _i896;
import 'features/categories/presentation/bloc/category_form/category_form_bloc.dart'
    as _i111;
import 'features/categories/presentation/bloc/category_list/category_list_bloc.dart'
    as _i848;
import 'features/dashboard/data/datasource/dashboard_local_datasource.dart'
    as _i910;
import 'features/dashboard/data/repository_impl/dashboard_repository_impl.dart'
    as _i104;
import 'features/dashboard/domain/repository/dashboard_repository.dart'
    as _i241;
import 'features/dashboard/domain/usecases/dashboard_usecases.dart' as _i516;
import 'features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart'
    as _i860;
import 'features/export/data/datasource/csv_export_generator.dart' as _i351;
import 'features/export/data/datasource/export_data_collector.dart' as _i655;
import 'features/export/data/datasource/export_local_datasource.dart' as _i965;
import 'features/export/data/datasource/pdf_export_generator.dart' as _i534;
import 'features/export/data/repository_impl/export_repository_impl.dart'
    as _i84;
import 'features/export/data/services/export_file_storage.dart' as _i613;
import 'features/export/data/services/export_share_service.dart' as _i768;
import 'features/export/domain/repository/export_repository.dart' as _i657;
import 'features/export/domain/usecases/export_usecases.dart' as _i515;
import 'features/export/presentation/bloc/export/export_bloc.dart' as _i862;
import 'features/goals/data/datasource/goal_local_datasource.dart' as _i43;
import 'features/goals/data/repository_impl/goal_repository_impl.dart'
    as _i1007;
import 'features/goals/domain/repository/goal_repository.dart' as _i1001;
import 'features/goals/domain/usecases/goal_usecases.dart' as _i200;
import 'features/goals/presentation/bloc/goal_detail/goal_detail_bloc.dart'
    as _i70;
import 'features/goals/presentation/bloc/goal_form/goal_form_bloc.dart'
    as _i811;
import 'features/goals/presentation/bloc/goal_list/goal_list_bloc.dart'
    as _i402;
import 'features/recurring_transactions/data/datasource/recurring_transaction_local_datasource.dart'
    as _i283;
import 'features/recurring_transactions/data/repository_impl/recurring_transaction_repository_impl.dart'
    as _i724;
import 'features/recurring_transactions/domain/repository/recurring_transaction_repository.dart'
    as _i486;
import 'features/recurring_transactions/domain/usecases/recurring_transaction_usecases.dart'
    as _i1047;
import 'features/recurring_transactions/presentation/bloc/recurring_detail/recurring_detail_bloc.dart'
    as _i742;
import 'features/recurring_transactions/presentation/bloc/recurring_form/recurring_form_bloc.dart'
    as _i699;
import 'features/recurring_transactions/presentation/bloc/recurring_list/recurring_list_bloc.dart'
    as _i485;
import 'features/reports/data/datasource/report_local_datasource.dart' as _i388;
import 'features/reports/data/repository_impl/report_repository_impl.dart'
    as _i369;
import 'features/reports/domain/repository/report_repository.dart' as _i735;
import 'features/reports/domain/usecases/report_usecases.dart' as _i562;
import 'features/reports/presentation/bloc/report_detail/report_detail_bloc.dart'
    as _i1020;
import 'features/settings/data/datasource/settings_local_datasource.dart'
    as _i152;
import 'features/settings/data/repository_impl/settings_repository_impl.dart'
    as _i609;
import 'features/settings/domain/repository/settings_repository.dart' as _i11;
import 'features/settings/domain/usecases/settings_usecases.dart' as _i229;
import 'features/settings/presentation/bloc/settings/settings_bloc.dart'
    as _i847;
import 'features/transactions/data/datasource/transaction_local_datasource.dart'
    as _i616;
import 'features/transactions/data/repository_impl/transaction_repository_impl.dart'
    as _i796;
import 'features/transactions/domain/repository/transaction_repository.dart'
    as _i951;
import 'features/transactions/domain/usecases/transaction_usecases.dart'
    as _i893;
import 'features/transactions/presentation/bloc/transaction_detail/transaction_detail_bloc.dart'
    as _i820;
import 'features/transactions/presentation/bloc/transaction_form/transaction_form_bloc.dart'
    as _i271;
import 'features/transactions/presentation/bloc/transaction_list/transaction_list_bloc.dart'
    as _i70;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final databaseModule = _$DatabaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.preferences,
      preResolve: true,
    );
    gh.lazySingleton<_i111.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i59.PasswordHasher>(() => _i59.PasswordHasher());
    gh.lazySingleton<_i351.CsvExportGenerator>(
      () => _i351.CsvExportGenerator(),
    );
    gh.lazySingleton<_i534.PdfExportGenerator>(
      () => _i534.PdfExportGenerator(),
    );
    gh.lazySingleton<_i613.ExportFileStorage>(() => _i613.ExportFileStorage());
    gh.lazySingleton<_i768.ExportShareService>(
      () => _i768.ExportShareService(),
    );
    gh.lazySingleton<_i246.AuthLocalDataSource>(
      () => _i246.AuthLocalDataSource(
        gh<_i111.AppDatabase>(),
        gh<_i460.SharedPreferences>(),
        gh<_i59.PasswordHasher>(),
      ),
    );
    gh.lazySingleton<_i898.BudgetLocalDataSource>(
      () => _i898.BudgetLocalDataSource(gh<_i111.AppDatabase>()),
    );
    gh.lazySingleton<_i71.CategoryLocalDataSource>(
      () => _i71.CategoryLocalDataSource(gh<_i111.AppDatabase>()),
    );
    gh.lazySingleton<_i43.GoalLocalDataSource>(
      () => _i43.GoalLocalDataSource(gh<_i111.AppDatabase>()),
    );
    gh.lazySingleton<_i616.TransactionLocalDataSource>(
      () => _i616.TransactionLocalDataSource(gh<_i111.AppDatabase>()),
    );
    gh.lazySingleton<_i646.LocaleStorage>(
      () => _i26.LocaleStorageImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i841.BudgetRepository>(
      () => _i15.BudgetRepositoryImpl(gh<_i898.BudgetLocalDataSource>()),
    );
    gh.lazySingleton<_i976.CategoryRepository>(
      () => _i851.CategoryRepositoryImpl(gh<_i71.CategoryLocalDataSource>()),
    );
    gh.lazySingleton<_i910.DashboardLocalDataSource>(
      () => _i910.DashboardLocalDataSource(
        gh<_i616.TransactionLocalDataSource>(),
        gh<_i898.BudgetLocalDataSource>(),
        gh<_i43.GoalLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i152.SettingsLocalDataSource>(
      () => _i152.SettingsLocalDataSource(gh<_i460.SharedPreferences>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i279.AuthRepository>(
      () => _i132.AuthRepositoryImpl(gh<_i246.AuthLocalDataSource>()),
    );
    gh.factory<_i896.WatchCategoriesUseCase>(
      () => _i896.WatchCategoriesUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i896.GetCategoriesUseCase>(
      () => _i896.GetCategoriesUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i896.GetCategoryByIdUseCase>(
      () => _i896.GetCategoryByIdUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i896.CreateCategoryUseCase>(
      () => _i896.CreateCategoryUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i896.UpdateCategoryUseCase>(
      () => _i896.UpdateCategoryUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i896.DeleteCategoryUseCase>(
      () => _i896.DeleteCategoryUseCase(gh<_i976.CategoryRepository>()),
    );
    gh.factory<_i536.GetAuthSessionUseCase>(
      () => _i536.GetAuthSessionUseCase(gh<_i279.AuthRepository>()),
    );
    gh.factory<_i536.LoginUseCase>(
      () => _i536.LoginUseCase(gh<_i279.AuthRepository>()),
    );
    gh.factory<_i536.RegisterUseCase>(
      () => _i536.RegisterUseCase(gh<_i279.AuthRepository>()),
    );
    gh.factory<_i536.ForgotPasswordUseCase>(
      () => _i536.ForgotPasswordUseCase(gh<_i279.AuthRepository>()),
    );
    gh.factory<_i536.SignOutUseCase>(
      () => _i536.SignOutUseCase(gh<_i279.AuthRepository>()),
    );
    gh.factory<_i536.HasRegisteredUsersUseCase>(
      () => _i536.HasRegisteredUsersUseCase(gh<_i279.AuthRepository>()),
    );
    gh.lazySingleton<_i241.DashboardRepository>(
      () => _i104.DashboardRepositoryImpl(gh<_i910.DashboardLocalDataSource>()),
    );
    gh.lazySingleton<_i388.ReportLocalDataSource>(
      () => _i388.ReportLocalDataSource(
        gh<_i616.TransactionLocalDataSource>(),
        gh<_i898.BudgetLocalDataSource>(),
        gh<_i43.GoalLocalDataSource>(),
        gh<_i71.CategoryLocalDataSource>(),
      ),
    );
    gh.factory<_i848.CategoryListBloc>(
      () => _i848.CategoryListBloc(
        gh<_i896.WatchCategoriesUseCase>(),
        gh<_i896.DeleteCategoryUseCase>(),
      ),
    );
    gh.lazySingleton<_i339.AuthBloc>(
      () => _i339.AuthBloc(
        gh<_i536.GetAuthSessionUseCase>(),
        gh<_i536.SignOutUseCase>(),
      ),
    );
    gh.factory<_i175.ForgotPasswordBloc>(
      () => _i175.ForgotPasswordBloc(gh<_i536.ForgotPasswordUseCase>()),
    );
    gh.lazySingleton<_i1001.GoalRepository>(
      () => _i1007.GoalRepositoryImpl(gh<_i43.GoalLocalDataSource>()),
    );
    gh.factory<_i111.CategoryFormBloc>(
      () => _i111.CategoryFormBloc(
        gh<_i896.GetCategoryByIdUseCase>(),
        gh<_i896.CreateCategoryUseCase>(),
        gh<_i896.UpdateCategoryUseCase>(),
      ),
    );
    gh.lazySingleton<_i56.LocaleService>(
      () => _i56.LocaleService(gh<_i646.LocaleStorage>()),
    );
    gh.factory<_i555.LoginBloc>(
      () => _i555.LoginBloc(gh<_i536.LoginUseCase>()),
    );
    gh.factory<_i649.RegisterBloc>(
      () => _i649.RegisterBloc(gh<_i536.RegisterUseCase>()),
    );
    gh.factory<_i747.WatchBudgetsUseCase>(
      () => _i747.WatchBudgetsUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.GetBudgetsUseCase>(
      () => _i747.GetBudgetsUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.GetBudgetByIdUseCase>(
      () => _i747.GetBudgetByIdUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.CreateBudgetUseCase>(
      () => _i747.CreateBudgetUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.UpdateBudgetUseCase>(
      () => _i747.UpdateBudgetUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.DeleteBudgetUseCase>(
      () => _i747.DeleteBudgetUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.factory<_i747.GetBudgetUsageUseCase>(
      () => _i747.GetBudgetUsageUseCase(gh<_i841.BudgetRepository>()),
    );
    gh.lazySingleton<_i11.SettingsRepository>(
      () => _i609.SettingsRepositoryImpl(gh<_i152.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i283.RecurringTransactionLocalDataSource>(
      () => _i283.RecurringTransactionLocalDataSource(
        gh<_i111.AppDatabase>(),
        gh<_i616.TransactionLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i951.TransactionRepository>(
      () => _i796.TransactionRepositoryImpl(
        gh<_i616.TransactionLocalDataSource>(),
      ),
    );
    gh.factory<_i516.GetDashboardDataUseCase>(
      () => _i516.GetDashboardDataUseCase(gh<_i241.DashboardRepository>()),
    );
    gh.factory<_i229.GetPreferencesUseCase>(
      () => _i229.GetPreferencesUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.SavePreferencesUseCase>(
      () => _i229.SavePreferencesUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.WatchPreferencesUseCase>(
      () => _i229.WatchPreferencesUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.ClearPreferencesUseCase>(
      () => _i229.ClearPreferencesUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.UpdateThemeModeUseCase>(
      () => _i229.UpdateThemeModeUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.UpdateCurrencyUseCase>(
      () => _i229.UpdateCurrencyUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i229.UpdateNotificationPreferencesUseCase>(
      () => _i229.UpdateNotificationPreferencesUseCase(
        gh<_i11.SettingsRepository>(),
      ),
    );
    gh.factory<_i229.UpdateExportPreferencesUseCase>(
      () => _i229.UpdateExportPreferencesUseCase(gh<_i11.SettingsRepository>()),
    );
    gh.factory<_i502.BudgetFormBloc>(
      () => _i502.BudgetFormBloc(
        gh<_i747.GetBudgetByIdUseCase>(),
        gh<_i747.CreateBudgetUseCase>(),
        gh<_i747.UpdateBudgetUseCase>(),
        gh<_i896.GetCategoriesUseCase>(),
      ),
    );
    gh.lazySingleton<_i735.ReportRepository>(
      () => _i369.ReportRepositoryImpl(gh<_i388.ReportLocalDataSource>()),
    );
    gh.lazySingleton<_i885.LocaleCubit>(
      () => _i885.LocaleCubit(gh<_i56.LocaleService>()),
    );
    gh.lazySingleton<_i655.ExportDataCollector>(
      () => _i655.ExportDataCollector(
        gh<_i616.TransactionLocalDataSource>(),
        gh<_i898.BudgetLocalDataSource>(),
        gh<_i43.GoalLocalDataSource>(),
        gh<_i388.ReportLocalDataSource>(),
      ),
    );
    gh.factory<_i893.WatchTransactionsUseCase>(
      () => _i893.WatchTransactionsUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.GetTransactionsUseCase>(
      () => _i893.GetTransactionsUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.GetTransactionByIdUseCase>(
      () => _i893.GetTransactionByIdUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.CreateTransactionUseCase>(
      () => _i893.CreateTransactionUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.UpdateTransactionUseCase>(
      () => _i893.UpdateTransactionUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.DeleteTransactionUseCase>(
      () => _i893.DeleteTransactionUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.factory<_i893.GetTransactionSummaryUseCase>(
      () =>
          _i893.GetTransactionSummaryUseCase(gh<_i951.TransactionRepository>()),
    );
    gh.lazySingleton<_i463.ThemeCubit>(
      () => _i463.ThemeCubit(
        gh<_i229.GetPreferencesUseCase>(),
        gh<_i229.UpdateThemeModeUseCase>(),
      ),
    );
    gh.lazySingleton<_i231.CurrencyCubit>(
      () => _i231.CurrencyCubit(
        gh<_i229.GetPreferencesUseCase>(),
        gh<_i229.UpdateCurrencyUseCase>(),
      ),
    );
    gh.lazySingleton<_i486.RecurringTransactionRepository>(
      () => _i724.RecurringTransactionRepositoryImpl(
        gh<_i283.RecurringTransactionLocalDataSource>(),
      ),
    );
    gh.factory<_i200.WatchGoalsUseCase>(
      () => _i200.WatchGoalsUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.GetGoalsUseCase>(
      () => _i200.GetGoalsUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.GetGoalByIdUseCase>(
      () => _i200.GetGoalByIdUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.CreateGoalUseCase>(
      () => _i200.CreateGoalUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.UpdateGoalUseCase>(
      () => _i200.UpdateGoalUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.DeleteGoalUseCase>(
      () => _i200.DeleteGoalUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.AddContributionUseCase>(
      () => _i200.AddContributionUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i200.GetGoalProgressUseCase>(
      () => _i200.GetGoalProgressUseCase(gh<_i1001.GoalRepository>()),
    );
    gh.factory<_i70.GoalDetailBloc>(
      () => _i70.GoalDetailBloc(
        gh<_i200.GetGoalProgressUseCase>(),
        gh<_i200.AddContributionUseCase>(),
        gh<_i200.DeleteGoalUseCase>(),
        gh<_i200.WatchGoalsUseCase>(),
      ),
    );
    gh.factory<_i70.TransactionListBloc>(
      () => _i70.TransactionListBloc(
        gh<_i893.WatchTransactionsUseCase>(),
        gh<_i893.DeleteTransactionUseCase>(),
        gh<_i893.GetTransactionSummaryUseCase>(),
        gh<_i896.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i562.GenerateReportUseCase>(
      () => _i562.GenerateReportUseCase(gh<_i735.ReportRepository>()),
    );
    gh.factory<_i536.DeleteAccountUseCase>(
      () => _i536.DeleteAccountUseCase(
        gh<_i279.AuthRepository>(),
        gh<_i11.SettingsRepository>(),
      ),
    );
    gh.factory<_i811.GoalFormBloc>(
      () => _i811.GoalFormBloc(
        gh<_i200.GetGoalByIdUseCase>(),
        gh<_i200.CreateGoalUseCase>(),
        gh<_i200.UpdateGoalUseCase>(),
      ),
    );
    gh.factory<_i735.BudgetListBloc>(
      () => _i735.BudgetListBloc(
        gh<_i747.WatchBudgetsUseCase>(),
        gh<_i747.DeleteBudgetUseCase>(),
        gh<_i747.GetBudgetUsageUseCase>(),
        gh<_i893.WatchTransactionsUseCase>(),
      ),
    );
    gh.lazySingleton<_i965.ExportLocalDataSource>(
      () => _i965.ExportLocalDataSource(
        gh<_i655.ExportDataCollector>(),
        gh<_i613.ExportFileStorage>(),
        gh<_i351.CsvExportGenerator>(),
        gh<_i534.PdfExportGenerator>(),
      ),
    );
    gh.factory<_i820.TransactionDetailBloc>(
      () => _i820.TransactionDetailBloc(
        gh<_i893.GetTransactionByIdUseCase>(),
        gh<_i893.DeleteTransactionUseCase>(),
      ),
    );
    gh.factory<_i1047.WatchRecurringTransactionsUseCase>(
      () => _i1047.WatchRecurringTransactionsUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.GetRecurringTransactionsUseCase>(
      () => _i1047.GetRecurringTransactionsUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.GetRecurringTransactionByIdUseCase>(
      () => _i1047.GetRecurringTransactionByIdUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.CreateRecurringTransactionUseCase>(
      () => _i1047.CreateRecurringTransactionUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.UpdateRecurringTransactionUseCase>(
      () => _i1047.UpdateRecurringTransactionUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.DeleteRecurringTransactionUseCase>(
      () => _i1047.DeleteRecurringTransactionUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.PauseRecurringTransactionUseCase>(
      () => _i1047.PauseRecurringTransactionUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.ResumeRecurringTransactionUseCase>(
      () => _i1047.ResumeRecurringTransactionUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i1047.ProcessDueRecurringTransactionsUseCase>(
      () => _i1047.ProcessDueRecurringTransactionsUseCase(
        gh<_i486.RecurringTransactionRepository>(),
      ),
    );
    gh.factory<_i402.GoalListBloc>(
      () => _i402.GoalListBloc(
        gh<_i200.WatchGoalsUseCase>(),
        gh<_i200.DeleteGoalUseCase>(),
        gh<_i200.GetGoalProgressUseCase>(),
      ),
    );
    gh.factory<_i558.BudgetDetailBloc>(
      () => _i558.BudgetDetailBloc(
        gh<_i747.GetBudgetUsageUseCase>(),
        gh<_i747.DeleteBudgetUseCase>(),
        gh<_i893.WatchTransactionsUseCase>(),
      ),
    );
    gh.factory<_i271.TransactionFormBloc>(
      () => _i271.TransactionFormBloc(
        gh<_i893.GetTransactionByIdUseCase>(),
        gh<_i893.CreateTransactionUseCase>(),
        gh<_i893.UpdateTransactionUseCase>(),
        gh<_i896.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i1020.ReportDetailBloc>(
      () => _i1020.ReportDetailBloc(
        gh<_i562.GenerateReportUseCase>(),
        gh<_i896.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i847.SettingsBloc>(
      () => _i847.SettingsBloc(
        gh<_i229.GetPreferencesUseCase>(),
        gh<_i229.SavePreferencesUseCase>(),
        gh<_i229.WatchPreferencesUseCase>(),
        gh<_i536.DeleteAccountUseCase>(),
        gh<_i56.LocaleService>(),
      ),
    );
    gh.factory<_i860.DashboardBloc>(
      () => _i860.DashboardBloc(
        gh<_i516.GetDashboardDataUseCase>(),
        gh<_i893.WatchTransactionsUseCase>(),
        gh<_i747.WatchBudgetsUseCase>(),
        gh<_i200.WatchGoalsUseCase>(),
      ),
    );
    gh.factory<_i742.RecurringDetailBloc>(
      () => _i742.RecurringDetailBloc(
        gh<_i1047.GetRecurringTransactionByIdUseCase>(),
        gh<_i1047.DeleteRecurringTransactionUseCase>(),
        gh<_i1047.PauseRecurringTransactionUseCase>(),
        gh<_i1047.ResumeRecurringTransactionUseCase>(),
        gh<_i1047.WatchRecurringTransactionsUseCase>(),
      ),
    );
    gh.lazySingleton<_i657.ExportRepository>(
      () => _i84.ExportRepositoryImpl(
        gh<_i965.ExportLocalDataSource>(),
        gh<_i768.ExportShareService>(),
      ),
    );
    gh.factory<_i485.RecurringListBloc>(
      () => _i485.RecurringListBloc(
        gh<_i1047.WatchRecurringTransactionsUseCase>(),
        gh<_i1047.DeleteRecurringTransactionUseCase>(),
        gh<_i1047.PauseRecurringTransactionUseCase>(),
        gh<_i1047.ResumeRecurringTransactionUseCase>(),
        gh<_i1047.ProcessDueRecurringTransactionsUseCase>(),
      ),
    );
    gh.factory<_i699.RecurringFormBloc>(
      () => _i699.RecurringFormBloc(
        gh<_i1047.GetRecurringTransactionByIdUseCase>(),
        gh<_i1047.CreateRecurringTransactionUseCase>(),
        gh<_i1047.UpdateRecurringTransactionUseCase>(),
        gh<_i896.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i515.ExportDataUseCase>(
      () => _i515.ExportDataUseCase(gh<_i657.ExportRepository>()),
    );
    gh.factory<_i515.ShareExportUseCase>(
      () => _i515.ShareExportUseCase(gh<_i657.ExportRepository>()),
    );
    gh.factory<_i862.ExportBloc>(
      () => _i862.ExportBloc(
        gh<_i515.ExportDataUseCase>(),
        gh<_i515.ShareExportUseCase>(),
        gh<_i229.GetPreferencesUseCase>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i540.StorageModule {}

class _$DatabaseModule extends _i878.DatabaseModule {}
