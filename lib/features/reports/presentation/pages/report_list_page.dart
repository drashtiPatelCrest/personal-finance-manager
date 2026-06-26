import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/financial_report.dart';
import '../widgets/report_type_card.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      constrainBodyWidth: true,
      appBar: AppAppBar(
        title: AppText(l10n.reportListTitle, variant: AppTextVariant.titleLarge),
      ),
      bodyPadding: context.horizontalPagePadding,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        itemCount: ReportType.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final type = ReportType.values[index];
          return ReportTypeCard(
            type: type,
            index: index,
            onTap: () => context.push(RoutePaths.reportDetailPath(type.name)),
          );
        },
      ),
    );
  }
}
