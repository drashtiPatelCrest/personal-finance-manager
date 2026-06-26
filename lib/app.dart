import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/l10n_config.dart';
import 'core/l10n/l10n_extensions.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/l10n/locale_state.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'injection.dart';
import 'l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AppView();
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      navigatorKey: _navigatorKey,
      authBloc: getIt<AuthBloc>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (context) => context.l10n.appTitle,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeState.materialThemeMode,
              locale: localeState.locale,
              localeListResolutionCallback: (deviceLocales, supportedLocales) {
                return L10nConfig.resolveLocale(
                  savedLocale: localeState.locale,
                  deviceLocales: deviceLocales ?? const <Locale>[],
                );
              },
              routerConfig: _appRouter.router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        );
      },
    );
  }
}
