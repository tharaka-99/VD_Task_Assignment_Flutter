import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/login_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final loginProvider = context.read<LoginProvider>();
    final success = await loginProvider.logout();
    if (!context.mounted) return;
    if (success) {
      if (loginProvider.successMessage != null) {
        AppSnackbar.showSuccess(context, loginProvider.successMessage!);
      }
      context.goNamed('login');
    } else {
      if (loginProvider.errorMessage != null) {
        AppSnackbar.showError(context, loginProvider.errorMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user =
        context.select<LoginProvider, UserEntity?>((p) => p.currentUser);
    final isLoading = context.select<LoginProvider, bool>((p) => p.isLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.cardBorder),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: FontAwesomeIcons.phone,
                    label: 'Mobile Number',
                    value: user?.mobileNumber ?? 'N/A',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email Address',
                    value: user?.email ?? 'N/A',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: FontAwesomeIcons.idCard,
                    label: 'Account ID',
                    value: user?.id ?? 'N/A',
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Log Out',
                    isLoading: isLoading,
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Center(
            child: FaIcon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
