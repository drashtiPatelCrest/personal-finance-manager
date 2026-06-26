abstract final class RoutePaths {
  static const String dashboard = '/';
  static const String settings = '/settings';
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String categories = '/categories';
  static const String categoryAdd = '/categories/add';
  static const String categoryEdit = '/categories/:id/edit';
  static const String transactions = '/transactions';
  static const String transactionAdd = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';
  static const String transactionEdit = '/transactions/:id/edit';

  static String categoryAddPath({String? type}) {
    if (type == null) {
      return categoryAdd;
    }
    return '$categoryAdd?type=$type';
  }

  static String categoryEditPath(String id) => '/categories/$id/edit';

  static String transactionAddPath({String? type}) {
    if (type == null) {
      return transactionAdd;
    }
    return '$transactionAdd?type=$type';
  }

  static String transactionDetailPath(String id) => '/transactions/$id';

  static String transactionEditPath(String id) => '/transactions/$id/edit';

  static const String budgets = '/budgets';
  static const String budgetAdd = '/budgets/add';
  static const String budgetDetail = '/budgets/:id';
  static const String budgetEdit = '/budgets/:id/edit';

  static String budgetAddPath({String? type}) {
    if (type == null) {
      return budgetAdd;
    }
    return '$budgetAdd?type=$type';
  }

  static String budgetDetailPath(String id) => '/budgets/$id';

  static String budgetEditPath(String id) => '/budgets/$id/edit';

  static const String goals = '/goals';
  static const String goalAdd = '/goals/add';
  static const String goalDetail = '/goals/:id';
  static const String goalEdit = '/goals/:id/edit';

  static String goalDetailPath(String id) => '/goals/$id';

  static String goalEditPath(String id) => '/goals/$id/edit';

  static const String recurring = '/recurring-transactions';
  static const String recurringAdd = '/recurring-transactions/add';
  static const String recurringDetail = '/recurring-transactions/:id';
  static const String recurringEdit = '/recurring-transactions/:id/edit';

  static String recurringAddPath({String? type}) {
    if (type == null) {
      return recurringAdd;
    }
    return '$recurringAdd?type=$type';
  }

  static String recurringDetailPath(String id) => '/recurring-transactions/$id';

  static String recurringEditPath(String id) => '/recurring-transactions/$id/edit';

  static const String reports = '/reports';
  static const String reportDetail = '/reports/:type';

  static String reportDetailPath(String type) => '/reports/$type';

  static const String export = '/export';
}
