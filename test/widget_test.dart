import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_manager/app.dart';
import 'package:personal_finance_manager/core/currency/currency_cubit.dart';
import 'package:personal_finance_manager/core/l10n/locale_cubit.dart';
import 'package:personal_finance_manager/core/theme/theme_cubit.dart';
import 'package:personal_finance_manager/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:personal_finance_manager/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('App renders', (WidgetTester tester) async {
    final localeCubit = getIt<LocaleCubit>();
    await localeCubit.load(
      deviceLocales: WidgetsBinding.instance.platformDispatcher.locales,
    );

    final themeCubit = getIt<ThemeCubit>();
    await themeCubit.load();

    final currencyCubit = getIt<CurrencyCubit>();
    await currencyCubit.load();

    final authBloc = getIt<AuthBloc>();
    await authBloc.initialize();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: localeCubit),
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: currencyCubit),
          BlocProvider.value(value: authBloc),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(App), findsOneWidget);
  });
}
