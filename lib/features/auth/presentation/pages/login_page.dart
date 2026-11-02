import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/responsive_auth_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAuthLayout(
      title: 'Welcome Back',
      subtitle:
          'Sign in to your account and manage your assignments seamlessly.',
      illustrationPath: AppAssets.loginIllustration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthHeader(
            title: 'Sign In',
            subtitle: 'Enter your credentials to continue',
          ),
          const SizedBox(height: 24),
          LoginForm(
            onNavigateToRegister: () => context.goNamed('register'),
            onNavigateToForgotPassword: () =>
                context.pushNamed('forgot-password'),
          ),
        ],
      ),
    );
  }
}
