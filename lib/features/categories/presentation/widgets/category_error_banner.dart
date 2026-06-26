import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/category_error_code.dart';
import '../utils/category_localization.dart';

class CategoryErrorBanner extends StatelessWidget {
  const CategoryErrorBanner({super.key, required this.errorCode});

  final CategoryErrorCode errorCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        context.categoryErrorMessage(errorCode),
        variant: AppTextVariant.bodySmall,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}
