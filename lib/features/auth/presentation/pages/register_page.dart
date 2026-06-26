import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../utils/auth_error_localization.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_page_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _displayNameController.dispose();
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
      create: (_) => getIt<RegisterBloc>(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess && state.session != null) {
            context.read<AuthBloc>().add(AuthLoggedIn(state.session!));
          }
        },
        builder: (context, state) {
          return AuthPageLayout(
            title: l10n.authRegisterTitle,
            subtitle: l10n.authRegisterSubtitle,
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
                    controller: _displayNameController,
                    label: l10n.authDisplayNameLabel,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.lg),
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
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _securityAnswerController,
                    label: l10n.authSecurityAnswerLabel,
                    helperText: l10n.authSecurityAnswerHint,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.authRegisterButton,
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
                  l10n.authHaveAccountPrompt,
                  variant: AppTextVariant.bodySmall,
                ),
                AppButton(
                  label: l10n.authLoginLink,
                  onPressed: () => context.go(RoutePaths.login),
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
    context.read<RegisterBloc>().add(
          RegisterSubmitted(
            displayName: _displayNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            securityAnswer: _securityAnswerController.text,
          ),
        );
  }
}
