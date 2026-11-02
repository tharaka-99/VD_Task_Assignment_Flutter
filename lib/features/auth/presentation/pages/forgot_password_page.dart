import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/responsive_auth_layout.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAuthLayout(
      title: 'Forgot Password?',
      subtitle:
          'Enter your registered email or mobile number to receive reset instructions.',
      illustrationPath: AppAssets.forgotPasswordIllustration,
      showIllustrationOnMobile: true,
      onBackPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed('login');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthHeader(
            title: 'Reset Password',
            subtitle: 'We will send you a recovery link',
            showLogo: false,
          ),
          const SizedBox(height: 24),
          ForgotPasswordForm(
            onNavigateToLogin: () => context.goNamed('login'),
          ),
        ],
      ),
    );
  }
}
