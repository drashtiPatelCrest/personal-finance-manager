import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/goal_error_code.dart';
import '../utils/goal_localization.dart';

class GoalErrorBanner extends StatelessWidget {
  const GoalErrorBanner({
    super.key,
    required this.errorCode,
  });

  final GoalErrorCode errorCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppText(
                context.goalErrorMessage(errorCode),
                variant: AppTextVariant.bodyMedium,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
