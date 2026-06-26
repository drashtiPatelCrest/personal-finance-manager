import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../utils/auth_error_localization.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_page_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSuccess && state.session != null) {
            context.read<AuthBloc>().add(AuthLoggedIn(state.session!));
          }
        },
        builder: (context, state) {
          return AuthPageLayout(
            title: l10n.authLoginTitle,
            subtitle: l10n.authLoginSubtitle,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.isFailure && state.errorCode != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: AuthErrorBanner(
                        message: context.authErrorMessage(state.errorCode!),
                      ),
                    ),
                  AppTextField(
                    controller: _emailController,
                    label: l10n.authEmailLabel,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _passwordController,
                    label: l10n.authPasswordLabel,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      label: l10n.authForgotPasswordLink,
                      onPressed: () => context.push(RoutePaths.forgotPassword),
                      variant: AppButtonVariant.text,
                      size: AppButtonSize.small,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.authLoginButton,
                    onPressed: state.isLoading ? null : () => _submit(context),
                    isExpanded: true,
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  l10n.authNoAccountPrompt,
                  variant: AppTextVariant.bodySmall,
                ),
                AppButton(
                  label: l10n.authRegisterLink,
                  onPressed: () => context.push(RoutePaths.register),
                  variant: AppButtonVariant.text,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(
          LoginSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }
}
