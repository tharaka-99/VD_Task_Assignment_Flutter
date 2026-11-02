import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/login_provider.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onNavigateToRegister;
  final VoidCallback? onNavigateToForgotPassword;

  const LoginForm({
    super.key,
    this.onNavigateToRegister,
    this.onNavigateToForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;
  bool _rememberMe = false;
  bool _initializedFromProvider = false;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final remembered = context.watch<LoginProvider>().rememberedIdentifier;
    if (!_initializedFromProvider && remembered != null && remembered.isNotEmpty) {
      if (_identifierController.text.isEmpty) {
        _identifierController.text = remembered;
        _rememberMe = true;
      }
      _initializedFromProvider = true;
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final loginProvider = context.read<LoginProvider>();
      final success = await loginProvider.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      if (success) {
        if (loginProvider.successMessage != null) {
          AppSnackbar.showSuccess(context, loginProvider.successMessage!);
        }
        context.goNamed('home');
      } else {
        if (loginProvider.errorMessage != null) {
          AppSnackbar.showError(context, loginProvider.errorMessage!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<LoginProvider, bool>((p) => p.isLoading);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _identifierController,
            label: 'Email or Mobile Number',
            hint: 'Enter Email or Mobile Number',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.validateLoginIdentifier,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.envelope,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            textInputAction: TextInputAction.done,
            validator: Validators.validatePassword,
            onFieldSubmitted: (_) => _submit(),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.lock,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: AppColors.inputBorder,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: const Text(
                      'Remember me',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onNavigateToForgotPassword ??
                    () => context.pushNamed('forgot-password'),
                child: const Text(
                  'Forgot Password?',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Sign In',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: AppTextStyles.bodyMedium,
              ),
              GestureDetector(
                onTap: widget.onNavigateToRegister ??
                    () => context.goNamed('register'),
                child: const Text(
                  'Sign Up',
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
