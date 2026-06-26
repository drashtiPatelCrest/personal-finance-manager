import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'daos/auth_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/category_dao.dart';
import 'daos/goal_dao.dart';
import 'daos/recurring_transaction_dao.dart';
import 'daos/transaction_dao.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/goal_contributions_table.dart';
import 'tables/recurring_transactions_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/transactions_table.dart';
import 'tables/users_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Categories,
    Transactions,
    Budgets,
    SavingsGoals,
    GoalContributions,
    RecurringTransactions,
  ],
  daos: [
    AuthDao,
    CategoryDao,
    TransactionDao,
    BudgetDao,
    GoalDao,
    RecurringTransactionDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (Migrator migrator, int from, int to) async {
        if (from < 2) {
          await migrator.createTable(users);
        }
        if (from < 3) {
          await migrator.addColumn(users, users.securityAnswerHash);
          await migrator.addColumn(users, users.securityAnswerSalt);
        }
        if (from < 4) {
          await migrator.createTable(categories);
          await migrator.createTable(transactions);
        }
        if (from < 5) {
          await migrator.createTable(budgets);
        }
        if (from < 6) {
          await migrator.createTable(savingsGoals);
          await migrator.createTable(goalContributions);
        }
        if (from < 7) {
          await migrator.createTable(recurringTransactions);
        }
      },
    );
  }

  /// Removes all user and financial data from the local database.
  Future<void> wipeAllData() async {
    await transaction(() async {
      await delete(recurringTransactions).go();
      await delete(goalContributions).go();
      await delete(savingsGoals).go();
      await delete(budgets).go();
      await delete(transactions).go();
      await delete(categories).go();
      await delete(users).go();
    });
  }
}
