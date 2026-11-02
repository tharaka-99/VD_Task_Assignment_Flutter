import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/phone_number_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/password_criteria_view.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/password_match_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/register_provider.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback? onNavigateToLogin;

  const RegisterForm({
    super.key,
    this.onNavigateToLogin,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onFieldChanged);
    _confirmPasswordController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final registerProvider = context.read<RegisterProvider>();
      final success = await registerProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        if (registerProvider.successMessage != null) {
          AppSnackbar.showSuccess(context, registerProvider.successMessage!);
        }
        context.goNamed('login');
      } else {
        if (registerProvider.errorMessage != null) {
          AppSnackbar.showError(context, registerProvider.errorMessage!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select<RegisterProvider, bool>((p) => p.isLoading);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'John Doe',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: Validators.validateName,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.user,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'john@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.validateEmail,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.envelope,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _mobileController,
            label: 'Mobile Number',
            hint: '0771234567 or +94700000327',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: const [
              PhoneNumberTextInputFormatter(),
            ],
            validator: Validators.validateMobile,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.phone,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 14),
          PasswordField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter Password',
            textInputAction: TextInputAction.next,
            validator: Validators.validatePassword,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(14),
              child: FaIcon(
                FontAwesomeIcons.lock,
                color: AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
          if (_passwordController.text.isNotEmpty) ...[
            PasswordCriteriaView(password: _passwordController.text),
          ],
          const SizedBox(height: 14),
          PasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            textInputAction: TextInputAction.done,
            validator: (val) => Validators.validateConfirmPassword(
              val,
              _passwordController.text,
            ),
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
          if (_confirmPasswordController.text.isNotEmpty) ...[
            PasswordMatchIndicator(
              isMatching: _confirmPasswordController.text ==
                  _passwordController.text,
            ),
          ],
          const SizedBox(height: 22),
          PrimaryButton(
            text: 'Create Account',
            isLoading: isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
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
