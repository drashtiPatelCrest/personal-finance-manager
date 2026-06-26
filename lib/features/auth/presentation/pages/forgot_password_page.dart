import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../bloc/forgot_password/forgot_password_bloc.dart';
import '../utils/auth_error_localization.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_page_layout.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => getIt<ForgotPasswordBloc>(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.isSuccess) {
            AppSnackBar.success(context, l10n.authPasswordResetSuccess);
            context.go(RoutePaths.login);
          }
        },
        builder: (context, state) {
          return AuthPageLayout(
            title: l10n.authForgotPasswordTitle,
            subtitle: l10n.authForgotPasswordSubtitle,
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
                    controller: _securityAnswerController,
                    label: l10n.authSecurityAnswerLabel,
                    helperText: l10n.authSecurityAnswerHint,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _passwordController,
                    label: l10n.authNewPasswordLabel,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _confirmPasswordController,
                    label: l10n.authConfirmPasswordLabel,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.authResetPasswordButton,
                    onPressed: state.isLoading ? null : () => _submit(context),
                    isExpanded: true,
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
            footer: AppButton(
              label: l10n.authBackToLoginLink,
              onPressed: () => context.go(RoutePaths.login),
              variant: AppButtonVariant.text,
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<ForgotPasswordBloc>().add(
          ForgotPasswordSubmitted(
            email: _emailController.text,
            securityAnswer: _securityAnswerController.text,
            newPassword: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
        );
  }
}
