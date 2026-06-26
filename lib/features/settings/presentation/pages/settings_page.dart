import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/currency_constants.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/l10n/l10n_config.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/l10n/locale_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../export/presentation/widgets/export_date_range_filter.dart';
import '../../domain/entities/user_preferences.dart';
import '../bloc/settings/settings_bloc.dart';
import '../utils/settings_localization.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(const SettingsStarted()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) =>
          previous.errorNonce != current.errorNonce ||
          previous.accountDeletedNonce != current.accountDeletedNonce,
      listener: (context, state) {
        if (state.errorCode != null) {
          AppSnackBar.error(
            context,
            state.errorCode!.message(l10n),
          );
        }

        if (state.accountDeleted) {
          context.read<ThemeCubit>().load();
          context.read<CurrencyCubit>().load();
          context.read<LocaleCubit>().resetToSystemLocale(
                deviceLocales:
                    WidgetsBinding.instance.platformDispatcher.locales,
              );
          context.read<AuthBloc>().add(const AuthAccountDeleted());
        }
      },
      builder: (context, state) {
        final preferences = state.preferences;

        return AppScaffold(
          appBar: AppAppBar(
            title: AppText(
              l10n.settingsTitle,
              variant: AppTextVariant.titleLarge,
            ),
          ),
          bodyPadding: const EdgeInsets.all(AppSpacing.lg),
          body: state.isLoading
              ? const Center(child: AppLoadingIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AppearanceSection(preferences: preferences),
                      const SizedBox(height: AppSpacing.lg),
                      _NotificationSection(preferences: preferences),
                      const SizedBox(height: AppSpacing.lg),
                      _ExportPreferencesSection(preferences: preferences),
                      const SizedBox(height: AppSpacing.lg),
                      _NavigationSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _AccountSection(isDeleting: state.isDeletingAccount),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeMode = context.watch<ThemeCubit>().state.themeMode;
    final currencyCode = context.watch<CurrencyCubit>().state.currencyCode;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(title: l10n.settingsAppearanceTitle),
          ...AppThemeMode.values.map(
            (mode) => AppRadioButton<AppThemeMode>(
              value: mode,
              groupValue: themeMode,
              label: mode.label(l10n),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                context.read<ThemeCubit>().setThemeMode(value);
              },
            ),
          ),
          const AppDivider(),
          AppDropdown<String>(
            label: l10n.settingsCurrencyLabel,
            value: currencyCode,
            items: CurrencyConstants.supportedCurrencies
                .map(
                  (currency) => DropdownMenuItem(
                    value: currency.code,
                    child: Text(
                      '${currency.label(l10n)} (${currency.symbol})',
                    ),
                  ),
                )
                .toList(),
            onChanged: (code) {
              if (code == null) {
                return;
              }
              context.read<CurrencyCubit>().setCurrencyCode(code);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<String>(
            label: l10n.settingsLanguageLabel,
            value: preferences.localeCode,
            items: L10nConfig.supportedLocales
                .map(
                  (locale) => DropdownMenuItem(
                    value: locale.languageCode,
                    child: Text(_languageLabel(l10n, locale.languageCode)),
                  ),
                )
                .toList(),
            onChanged: (languageCode) {
              if (languageCode == null) {
                return;
              }
              final locale = L10nConfig.localeFromLanguageCode(languageCode);
              if (locale == null) {
                return;
              }
              context.read<LocaleCubit>().setLocale(locale);
              context.read<SettingsBloc>().add(SettingsLocaleChanged(locale));
            },
          ),
        ],
      ),
    );
  }

  String _languageLabel(dynamic l10n, String languageCode) {
    return switch (languageCode) {
      'en' => l10n.languageEnglish,
      _ => languageCode,
    };
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifications = preferences.notifications;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(
            title: l10n.settingsNotificationsTitle,
            subtitle: l10n.settingsNotificationsSubtitle,
          ),
          AppSwitch(
            label: SettingsNotificationType.budgetWarning.label(l10n),
            value: notifications.budgetWarningEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.budgetWarning,
              enabled,
            ),
          ),
          AppSwitch(
            label: SettingsNotificationType.budgetExceeded.label(l10n),
            value: notifications.budgetExceededEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.budgetExceeded,
              enabled,
            ),
          ),
          AppSwitch(
            label: SettingsNotificationType.goalReminder.label(l10n),
            value: notifications.goalReminderEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.goalReminder,
              enabled,
            ),
          ),
          AppSwitch(
            label: SettingsNotificationType.goalDeadline.label(l10n),
            value: notifications.goalDeadlineEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.goalDeadline,
              enabled,
            ),
          ),
          AppSwitch(
            label: SettingsNotificationType.recurringReminder.label(l10n),
            value: notifications.recurringReminderEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.recurringReminder,
              enabled,
            ),
          ),
          AppSwitch(
            label: SettingsNotificationType.monthlySummary.label(l10n),
            value: notifications.monthlySummaryEnabled,
            onChanged: (enabled) => _toggle(
              context,
              SettingsNotificationType.monthlySummary,
              enabled,
            ),
          ),
        ],
      ),
    );
  }

  void _toggle(
    BuildContext context,
    SettingsNotificationType type,
    bool enabled,
  ) {
    context.read<SettingsBloc>().add(
          SettingsNotificationToggled(type: type, enabled: enabled),
        );
  }
}

class _ExportPreferencesSection extends StatelessWidget {
  const _ExportPreferencesSection({required this.preferences});

  final UserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final export = preferences.export;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(
            title: l10n.settingsExportPreferencesTitle,
            subtitle: l10n.settingsExportPreferencesSubtitle,
          ),
          AppSwitch(
            label: l10n.settingsExportUseDateFilter,
            value: export.useDateFilter,
            onChanged: (enabled) {
              context.read<SettingsBloc>().add(
                    SettingsExportDateFilterToggled(enabled),
                  );
            },
          ),
          if (export.useDateFilter) ...[
            const SizedBox(height: AppSpacing.md),
            ExportDateRangeFilter(
              selectedPreset: export.dateRangePreset,
              onChanged: (preset) {
                context.read<SettingsBloc>().add(
                      SettingsExportDateRangeChanged(preset),
                    );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _NavigationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        children: [
          AppListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: Text(l10n.reportListTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.reports),
          ),
          AppListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: Text(l10n.exportTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RoutePaths.export),
          ),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({required this.isDeleting});

  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = context.watch<AuthBloc>().state;
    final userId = authState.session?.user.id;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(title: l10n.settingsAccountTitle),
          AppButton(
            label: l10n.authSignOutButton,
            onPressed: isDeleting
                ? null
                : () => context.read<AuthBloc>().add(const AuthLoggedOut()),
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.md),
          AppOutlinedButton(
            label: l10n.settingsDeleteAccountButton,
            onPressed: isDeleting || userId == null
                ? null
                : () => _confirmDeleteAccount(context, userId),
            isExpanded: true,
          ),
          if (isDeleting) ...[
            const SizedBox(height: AppSpacing.md),
            const Center(child: AppLoadingIndicator()),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context, int userId) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: l10n.settingsDeleteAccountConfirmTitle,
      message: l10n.settingsDeleteAccountConfirmMessage,
      confirmLabel: l10n.settingsDeleteAccountButton,
      isDestructive: true,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    context.read<SettingsBloc>().add(
          SettingsDeleteAccountRequested(userId: userId),
        );
  }
}
