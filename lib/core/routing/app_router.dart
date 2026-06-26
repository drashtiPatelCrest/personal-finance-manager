import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/budgets/domain/entities/budget.dart';
import '../../features/budgets/presentation/pages/budget_detail_page.dart';
import '../../features/budgets/presentation/pages/budget_form_page.dart';
import '../../features/budgets/presentation/pages/budget_list_page.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/categories/presentation/pages/category_form_page.dart';
import '../../features/categories/presentation/pages/category_list_page.dart';
import '../../features/goals/presentation/pages/goal_detail_page.dart';
import '../../features/goals/presentation/pages/goal_form_page.dart';
import '../../features/goals/presentation/pages/goal_list_page.dart';
import '../../features/recurring_transactions/presentation/pages/recurring_detail_page.dart';
import '../../features/recurring_transactions/presentation/pages/recurring_form_page.dart';
import '../../features/recurring_transactions/presentation/pages/recurring_list_page.dart';
import '../../features/export/presentation/pages/export_page.dart';
import '../../features/reports/presentation/pages/report_detail_page.dart';
import '../../features/reports/presentation/pages/report_list_page.dart';
import '../../features/reports/presentation/utils/report_type_parser.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../features/transactions/presentation/pages/transaction_detail_page.dart';
import '../../features/transactions/presentation/pages/transaction_form_page.dart';
import '../../features/transactions/presentation/pages/transaction_list_page.dart';
import '../constants/route_paths.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter({
    required GlobalKey<NavigatorState> navigatorKey,
    required AuthBloc authBloc,
  }) : router = GoRouter(
          navigatorKey: navigatorKey,
          initialLocation: RoutePaths.dashboard,
          refreshListenable: GoRouterRefreshStream(authBloc.stream),
          redirect: (context, state) => _redirect(authBloc, state),
          routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
            GoRoute(
              path: RoutePaths.settings,
              name: 'settings',
              builder: (context, state) => const SettingsPage(),
            ),
            GoRoute(
              path: RoutePaths.categories,
              name: 'categories',
              builder: (context, state) => const CategoryListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'category-add',
                  builder: (context, state) => CategoryFormPage(
                    initialType: _parseCategoryType(
                      state.uri.queryParameters['type'],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id/edit',
                  name: 'category-edit',
                  builder: (context, state) => CategoryFormPage(
                    categoryId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.transactions,
              name: 'transactions',
              builder: (context, state) => const TransactionListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'transaction-add',
                  builder: (context, state) => TransactionFormPage(
                    initialType: _parseTransactionType(
                      state.uri.queryParameters['type'],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  name: 'transaction-detail',
                  builder: (context, state) => TransactionDetailPage(
                    transactionId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'transaction-edit',
                      builder: (context, state) => TransactionFormPage(
                        transactionId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.budgets,
              name: 'budgets',
              builder: (context, state) => const BudgetListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'budget-add',
                  builder: (context, state) => BudgetFormPage(
                    initialType: _parseBudgetType(
                      state.uri.queryParameters['type'],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  name: 'budget-detail',
                  builder: (context, state) => BudgetDetailPage(
                    budgetId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'budget-edit',
                      builder: (context, state) => BudgetFormPage(
                        budgetId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.goals,
              name: 'goals',
              builder: (context, state) => const GoalListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'goal-add',
                  builder: (context, state) => const GoalFormPage(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'goal-detail',
                  builder: (context, state) => GoalDetailPage(
                    goalId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'goal-edit',
                      builder: (context, state) => GoalFormPage(
                        goalId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.recurring,
              name: 'recurring-transactions',
              builder: (context, state) => const RecurringListPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'recurring-add',
                  builder: (context, state) => RecurringFormPage(
                    initialType: _parseTransactionType(
                      state.uri.queryParameters['type'],
                    ),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  name: 'recurring-detail',
                  builder: (context, state) => RecurringDetailPage(
                    recurringId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'recurring-edit',
                      builder: (context, state) => RecurringFormPage(
                        recurringId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.reports,
              name: 'reports',
              builder: (context, state) => const ReportListPage(),
              routes: [
                GoRoute(
                  path: ':type',
                  name: 'report-detail',
                  builder: (context, state) {
                    final reportType = parseReportType(
                      state.pathParameters['type'],
                    );
                    if (reportType == null) {
                      return const ReportListPage();
                    }
                    return ReportDetailPage(reportType: reportType);
                  },
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.export,
              name: 'export',
              builder: (context, state) => const ExportPage(),
            ),
            GoRoute(
              path: RoutePaths.login,
              name: 'login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: RoutePaths.register,
              name: 'register',
              builder: (context, state) => const RegisterPage(),
            ),
            GoRoute(
              path: RoutePaths.forgotPassword,
              name: 'forgot-password',
              builder: (context, state) => const ForgotPasswordPage(),
            ),
          ],
        );

  final GoRouter router;

  static String? _redirect(AuthBloc authBloc, GoRouterState state) {
    final authState = authBloc.state;
    final location = state.matchedLocation;
    final isAuthRoute = location.startsWith(RoutePaths.auth);

    if (authState.status != AuthStatus.authenticated && !isAuthRoute) {
      return RoutePaths.login;
    }

    if (authState.status == AuthStatus.authenticated && isAuthRoute) {
      return RoutePaths.dashboard;
    }

    return null;
  }

  static CategoryType? _parseCategoryType(String? value) {
    return switch (value) {
      'income' => CategoryType.income,
      'expense' => CategoryType.expense,
      _ => null,
    };
  }

  static TransactionType? _parseTransactionType(String? value) {
    return switch (value) {
      'income' => TransactionType.income,
      'expense' => TransactionType.expense,
      _ => null,
    };
  }

  static BudgetType? _parseBudgetType(String? value) {
    return switch (value) {
      'overall' => BudgetType.overall,
      'category' => BudgetType.category,
      _ => null,
    };
  }
}
