import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/budget_error_code.dart';
import '../utils/budget_localization.dart';

class BudgetErrorBanner extends StatelessWidget {
  const BudgetErrorBanner({
    super.key,
    required this.errorCode,
  });

  final BudgetErrorCode errorCode;

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
                context.budgetErrorMessage(errorCode),
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
