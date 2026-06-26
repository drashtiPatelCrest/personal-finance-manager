import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/goal_params.dart';
import 'package:personal_finance_manager/features/goals/domain/entities/savings_goal.dart';

void main() {
  final deadline = DateTime(2026, 12, 31);

  group('CreateGoalParams', () {
    test('supports value equality', () {
      final first = CreateGoalParams(
        name: 'Vacation',
        targetAmount: 5000,
        deadline: deadline,
      );
      final second = CreateGoalParams(
        name: 'Vacation',
        targetAmount: 5000,
        deadline: deadline,
      );

      expect(first, equals(second));
    });
  });

  group('GoalProgress status', () {
    test('returns completed when target reached', () {
      final status = GoalProgress.resolveGoalStatus(
        currentAmount: 1000,
        targetAmount: 1000,
        deadline: deadline,
      );

      expect(status, GoalStatus.completed);
    });

    test('returns expired when past deadline', () {
      final status = GoalProgress.resolveGoalStatus(
        currentAmount: 500,
        targetAmount: 1000,
        deadline: DateTime(2020, 1, 1),
        referenceDate: DateTime(2026, 6, 1),
      );

      expect(status, GoalStatus.expired);
    });

    test('returns active when in progress', () {
      final status = GoalProgress.resolveGoalStatus(
        currentAmount: 250,
        targetAmount: 1000,
        deadline: DateTime(2027, 1, 1),
        referenceDate: DateTime(2026, 6, 1),
      );

      expect(status, GoalStatus.active);
    });
  });

  group('GoalProgress completion percentage', () {
    test('calculates percentage correctly', () {
      final percentage = GoalProgress.calculateCompletionPercentage(
        currentAmount: 250,
        targetAmount: 1000,
      );

      expect(percentage, 25);
    });

    test('returns zero for invalid target', () {
      final percentage = GoalProgress.calculateCompletionPercentage(
        currentAmount: 100,
        targetAmount: 0,
      );

      expect(percentage, 0);
    });
  });
}
