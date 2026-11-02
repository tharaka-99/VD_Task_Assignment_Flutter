import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback? onNavigateToLogin;

  const ForgotPasswordForm({
    super.key,
    this.onNavigateToLogin,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final forgotProvider = context.read<ForgotPasswordProvider>();
      final success = await forgotProvider.forgotPassword(
        identifier: _identifierController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        if (forgotProvider.successMessage != null) {
          AppSnackbar.showSuccess(context, forgotProvider.successMessage!);
        }
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.goNamed('login');
          }
        });
      } else {
        if (forgotProvider.errorMessage != null) {
          AppSnackbar.showError(context, forgotProvider.errorMessage!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<ForgotPasswordProvider, bool>((p) => p.isLoading);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _identifierController,
            label: 'Email or Mobile Number',
            hint: 'test@example.com or 0771234567',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.validateLoginIdentifier,
            onFieldSubmitted: (_) => _submit(),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.envelope,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Reset Password',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Remember your password? ',
                style: AppTextStyles.bodyMedium,
              ),
              GestureDetector(
                onTap: widget.onNavigateToLogin ??
                    () => context.goNamed('login'),
                child: const Text(
                  'Sign In',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
