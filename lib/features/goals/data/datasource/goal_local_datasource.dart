import 'package:drift/drift.dart' show Value;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/goal_error_code.dart';
import '../../domain/entities/goal_params.dart';
import '../../domain/entities/savings_goal.dart';

@lazySingleton
class GoalLocalDataSource {
  GoalLocalDataSource(this._database);

  final db.AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<SavingsGoal>> watchGoals({GoalStatus? status, String? query}) {
    return _database.goalDao
        .watchGoals(
          query: query,
        )
        .asyncMap((rows) async {
      final goals = <SavingsGoal>[];
      for (final row in rows) {
        goals.add(await _mapAndSyncRow(row));
      }
      if (status == null) {
        return goals;
      }
      return goals.where((goal) => goal.status == status).toList();
    });
  }

  Future<List<SavingsGoal>> getGoals({GoalStatus? status, String? query}) async {
    final rows = await _database.goalDao.getGoals(
      query: query,
    );
    final goals = <SavingsGoal>[];
    for (final row in rows) {
      goals.add(await _mapAndSyncRow(row));
    }
    if (status == null) {
      return goals;
    }
    return goals.where((goal) => goal.status == status).toList();
  }

  Future<SavingsGoal?> getGoalById(String id) async {
    final row = await _database.goalDao.getGoalById(id);
    return row == null ? null : _mapAndSyncRow(row);
  }

  Future<SavingsGoal> createGoal(CreateGoalParams params) async {
    _validateName(params.name);
    _validateTargetAmount(params.targetAmount);
    _validateDeadline(params.deadline);

    final trimmedName = params.name.trim();
    final exists = await _database.goalDao.goalNameExists(name: trimmedName);
    if (exists) {
      throw const GoalException(GoalErrorCode.duplicateName);
    }

    final now = DateTime.now();
    final id = _uuid.v4();
    final status = GoalProgress.resolveGoalStatus(
      currentAmount: 0,
      targetAmount: params.targetAmount,
      deadline: params.deadline,
    );

    await _database.goalDao.insertGoal(
      db.SavingsGoalsCompanion.insert(
        id: id,
        name: trimmedName,
        targetAmount: params.targetAmount,
        currentAmount: const Value(0),
        deadline: params.deadline,
        status: _encodeStatus(status)!,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final created = await getGoalById(id);
    if (created == null) {
      throw const GoalException(GoalErrorCode.unknown);
    }
    return created;
  }

  Future<SavingsGoal> updateGoal(UpdateGoalParams params) async {
    _validateName(params.name);
    _validateTargetAmount(params.targetAmount);

    final existing = await getGoalById(params.id);
    if (existing == null) {
      throw const GoalException(GoalErrorCode.goalNotFound);
    }

    _validateDeadline(params.deadline, existingDeadline: existing.deadline);

    final trimmedName = params.name.trim();
    final exists = await _database.goalDao.goalNameExists(
      name: trimmedName,
      excludeId: params.id,
    );
    if (exists) {
      throw const GoalException(GoalErrorCode.duplicateName);
    }

    final status = GoalProgress.resolveGoalStatus(
      currentAmount: existing.currentAmount,
      targetAmount: params.targetAmount,
      deadline: params.deadline,
    );

    final updated = await _database.goalDao.updateGoal(
      db.SavingsGoalsCompanion(
        id: Value(params.id),
        name: Value(trimmedName),
        targetAmount: Value(params.targetAmount),
        deadline: Value(params.deadline),
        status: Value(_encodeStatus(status)!),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (!updated) {
      throw const GoalException(GoalErrorCode.unknown);
    }

    final goal = await getGoalById(params.id);
    if (goal == null) {
      throw const GoalException(GoalErrorCode.unknown);
    }
    return goal;
  }

  Future<void> deleteGoal(String id) async {
    final existing = await getGoalById(id);
    if (existing == null) {
      throw const GoalException(GoalErrorCode.goalNotFound);
    }

    final deleted = await _database.goalDao.deleteGoal(id);
    if (!deleted) {
      throw const GoalException(GoalErrorCode.unknown);
    }
  }

  Future<SavingsGoal> addContribution(AddContributionParams params) async {
    _validateContributionAmount(params.amount);

    final goal = await getGoalById(params.goalId);
    if (goal == null) {
      throw const GoalException(GoalErrorCode.goalNotFound);
    }
    if (goal.status == GoalStatus.completed) {
      throw const GoalException(GoalErrorCode.goalCompleted);
    }
    if (goal.status == GoalStatus.expired) {
      throw const GoalException(GoalErrorCode.goalExpired);
    }

    final now = DateTime.now();
    final contributionId = _uuid.v4();
    await _database.transaction(() async {
      await _database.goalDao.insertContribution(
        db.GoalContributionsCompanion.insert(
          id: contributionId,
          goalId: params.goalId,
          amount: params.amount,
          date: params.date,
          createdAt: now,
        ),
      );

      final newAmount = goal.currentAmount + params.amount;
      final status = GoalProgress.resolveGoalStatus(
        currentAmount: newAmount,
        targetAmount: goal.targetAmount,
        deadline: goal.deadline,
      );

      final updated = await _database.goalDao.updateGoal(
        db.SavingsGoalsCompanion(
          id: Value(params.goalId),
          currentAmount: Value(newAmount),
          status: Value(_encodeStatus(status)!),
          updatedAt: Value(now),
        ),
      );
      if (!updated) {
        throw const GoalException(GoalErrorCode.unknown);
      }
    });

    final updatedGoal = await getGoalById(params.goalId);
    if (updatedGoal == null) {
      throw const GoalException(GoalErrorCode.unknown);
    }
    return updatedGoal;
  }

  Future<GoalProgress> getGoalProgress(String goalId) async {
    final goal = await getGoalById(goalId);
    if (goal == null) {
      throw const GoalException(GoalErrorCode.goalNotFound);
    }

    final contributionRows =
        await _database.goalDao.getContributionsForGoal(goalId);
    final contributions = contributionRows.map(_mapContributionRow).toList();

    return GoalProgress(
      goal: goal,
      completionPercentage: GoalProgress.calculateCompletionPercentage(
        currentAmount: goal.currentAmount,
        targetAmount: goal.targetAmount,
      ),
      contributions: contributions,
    );
  }

  Future<SavingsGoal> _mapAndSyncRow(db.SavingsGoal row) async {
    final currentAmount = row.currentAmount;
    final status = GoalProgress.resolveGoalStatus(
      currentAmount: currentAmount,
      targetAmount: row.targetAmount,
      deadline: row.deadline,
    );
    final encodedStatus = _encodeStatus(status)!;

    if (encodedStatus != row.status) {
      await _database.goalDao.updateGoal(
        db.SavingsGoalsCompanion(
          id: Value(row.id),
          status: Value(encodedStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    return SavingsGoal(
      id: row.id,
      name: row.name,
      targetAmount: row.targetAmount,
      currentAmount: currentAmount,
      deadline: row.deadline,
      status: status,
    );
  }

  void _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const GoalException(GoalErrorCode.nameRequired);
    }
    if (trimmed.length < 2) {
      throw const GoalException(GoalErrorCode.nameTooShort);
    }
  }

  void _validateTargetAmount(double amount) {
    if (amount.isNaN || amount <= 0) {
      throw const GoalException(GoalErrorCode.targetAmountInvalid);
    }
  }

  void _validateDeadline(DateTime deadline, {DateTime? existingDeadline}) {
    if (existingDeadline != null) {
      final existingDay = DateTime(
        existingDeadline.year,
        existingDeadline.month,
        existingDeadline.day,
      );
      final deadlineDay =
          DateTime(deadline.year, deadline.month, deadline.day);
      if (deadlineDay == existingDay) {
        return;
      }
    }

    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final deadlineDay =
        DateTime(deadline.year, deadline.month, deadline.day);
    if (deadlineDay.isBefore(startOfToday)) {
      throw const GoalException(GoalErrorCode.deadlineInvalid);
    }
  }

  void _validateContributionAmount(double amount) {
    if (amount.isNaN || amount <= 0) {
      throw const GoalException(GoalErrorCode.contributionAmountInvalid);
    }
  }

  GoalContribution _mapContributionRow(db.GoalContribution row) {
    return GoalContribution(
      id: row.id,
      goalId: row.goalId,
      amount: row.amount,
      date: row.date,
    );
  }

  String? _encodeStatus(GoalStatus? status) {
    return switch (status) {
      GoalStatus.active => 'active',
      GoalStatus.completed => 'completed',
      GoalStatus.expired => 'expired',
      null => null,
    };
  }
}
