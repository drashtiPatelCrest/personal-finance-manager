import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/currency/currency_cubit.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/theme/theme_cubit.dart';
import 'core/usecases/usecase.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/recurring_transactions/domain/usecases/recurring_transaction_usecases.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

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

  try {
    await getIt<ProcessDueRecurringTransactionsUseCase>()(const NoParams());
  } catch (_) {
    // Do not block app launch if due processing fails.
  }

  runApp(
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
}
