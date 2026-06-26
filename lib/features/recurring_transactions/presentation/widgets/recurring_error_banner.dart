import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/recurring_transaction_error_code.dart';
import '../utils/recurring_localization.dart';

class RecurringErrorBanner extends StatelessWidget {
  const RecurringErrorBanner({
    super.key,
    required this.errorCode,
  });

  final RecurringTransactionErrorCode errorCode;

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
                context.recurringErrorMessage(errorCode),
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
