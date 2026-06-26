import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/core/database/app_database.dart';
import 'package:personal_finance_manager/features/goals/data/datasource/goal_local_datasource.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/goal_error_code.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/goal_params.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/savings_goal.dart';

class _TestAppDatabase extends AppDatabase {
  _TestAppDatabase() : super.forTesting(NativeDatabase.memory());
}

void main() {
  late _TestAppDatabase database;
  late GoalLocalDataSource dataSource;

  setUp(() async {
    database = _TestAppDatabase();
    dataSource = GoalLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  Future<String> _insertStaleActiveGoal(String name) async {
    const id = 'stale-goal';
    final now = DateTime.now();
    await database.goalDao.insertGoal(
      SavingsGoalsCompanion.insert(
        id: id,
        name: name,
        targetAmount: 1000,
        deadline: DateTime(2020, 1, 1),
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  test('createGoal stores and returns a goal', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Vacation Fund',
        targetAmount: 5000,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    expect(goal.name, 'Vacation Fund');
    expect(goal.targetAmount, 5000);
    expect(goal.currentAmount, 0);
    expect(goal.status, GoalStatus.active);
  });

  test('createGoal rejects invalid target amount', () async {
    expect(
      () => dataSource.createGoal(
        CreateGoalParams(
          name: 'Invalid',
          targetAmount: 0,
          deadline: DateTime(2026, 12, 31),
        ),
      ),
      throwsA(
        isA<GoalException>().having(
          (error) => error.code,
          'code',
          GoalErrorCode.targetAmountInvalid,
        ),
      ),
    );
  });

  test('createGoal rejects past deadline', () async {
    expect(
      () => dataSource.createGoal(
        CreateGoalParams(
          name: 'Late Goal',
          targetAmount: 100,
          deadline: DateTime(2020, 1, 1),
        ),
      ),
      throwsA(
        isA<GoalException>().having(
          (error) => error.code,
          'code',
          GoalErrorCode.deadlineInvalid,
        ),
      ),
    );
  });

  test('addContribution updates amount and completes goal', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Emergency Fund',
        targetAmount: 1000,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    final updated = await dataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 1000,
        date: DateTime(2026, 3, 1),
      ),
    );

    expect(updated.currentAmount, 1000);
    expect(updated.status, GoalStatus.completed);
  });

  test('addContribution rejects expired goal', () async {
    final goalId = await _insertStaleActiveGoal('Expired Goal');
    final goal = await dataSource.getGoalById(goalId);
    expect(goal?.status, GoalStatus.expired);

    expect(
      () => dataSource.addContribution(
        AddContributionParams(
          goalId: goalId,
          amount: 50,
          date: DateTime(2026, 1, 1),
        ),
      ),
      throwsA(
        isA<GoalException>().having(
          (error) => error.code,
          'code',
          GoalErrorCode.goalExpired,
        ),
      ),
    );
  });

  test('updateGoal allows editing expired goal without changing deadline', () async {
    final goalId = await _insertStaleActiveGoal('Old Goal');
    final goal = await dataSource.getGoalById(goalId);

    final updated = await dataSource.updateGoal(
      UpdateGoalParams(
        id: goalId,
        name: 'Renamed Goal',
        targetAmount: 1200,
        deadline: goal!.deadline,
      ),
    );

    expect(updated.name, 'Renamed Goal');
    expect(updated.targetAmount, 1200);
  });

  test('getGoals filters expired goals after status sync', () async {
    await _insertStaleActiveGoal('Stale Expired');

    final expiredGoals = await dataSource.getGoals(status: GoalStatus.expired);

    expect(expiredGoals, hasLength(1));
    expect(expiredGoals.first.status, GoalStatus.expired);
  });

  test('addContribution rejects completed goal', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Done Goal',
        targetAmount: 100,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    await dataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 100,
        date: DateTime(2026, 1, 1),
      ),
    );

    expect(
      () => dataSource.addContribution(
        AddContributionParams(
          goalId: goal.id,
          amount: 10,
          date: DateTime(2026, 2, 1),
        ),
      ),
      throwsA(
        isA<GoalException>().having(
          (error) => error.code,
          'code',
          GoalErrorCode.goalCompleted,
        ),
      ),
    );
  });

  test('getGoalProgress returns contributions and percentage', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Laptop',
        targetAmount: 2000,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    await dataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 500,
        date: DateTime(2026, 2, 1),
      ),
    );
    await dataSource.addContribution(
      AddContributionParams(
        goalId: goal.id,
        amount: 500,
        date: DateTime(2026, 3, 1),
      ),
    );

    final progress = await dataSource.getGoalProgress(goal.id);

    expect(progress.goal.currentAmount, 1000);
    expect(progress.completionPercentage, 50);
    expect(progress.contributions, hasLength(2));
  });

  test('updateGoal updates fields', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Car',
        targetAmount: 10000,
        deadline: DateTime(2026, 6, 30),
      ),
    );

    final updated = await dataSource.updateGoal(
      UpdateGoalParams(
        id: goal.id,
        name: 'New Car',
        targetAmount: 12000,
        deadline: DateTime(2027, 6, 30),
      ),
    );

    expect(updated.name, 'New Car');
    expect(updated.targetAmount, 12000);
  });

  test('createGoal rejects duplicate names', () async {
    await dataSource.createGoal(
      CreateGoalParams(
        name: 'Vacation',
        targetAmount: 1000,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    expect(
      () => dataSource.createGoal(
        CreateGoalParams(
          name: 'Vacation',
          targetAmount: 2000,
          deadline: DateTime(2027, 12, 31),
        ),
      ),
      throwsA(
        isA<GoalException>().having(
          (error) => error.code,
          'code',
          GoalErrorCode.duplicateName,
        ),
      ),
    );
  });

  test('deleteGoal removes an existing goal', () async {
    final goal = await dataSource.createGoal(
      CreateGoalParams(
        name: 'Temp',
        targetAmount: 100,
        deadline: DateTime(2026, 12, 31),
      ),
    );

    await dataSource.deleteGoal(goal.id);

    final result = await dataSource.getGoalById(goal.id);
    expect(result, isNull);
  });
}
