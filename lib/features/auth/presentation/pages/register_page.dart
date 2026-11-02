import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/responsive_auth_layout.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAuthLayout(
      title: 'Join Us Today',
      subtitle:
          'Create an account to start managing and tracking your assignments.',
      illustrationPath: AppAssets.registerIllustration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthHeader(
            title: 'Create Account',
            subtitle: 'Fill in your details below to get started',
            showLogo: false,
          ),
          const SizedBox(height: 24),
          RegisterForm(
            onNavigateToLogin: () => context.goNamed('login'),
          ),
        ],
      ),
    );
  }
}
