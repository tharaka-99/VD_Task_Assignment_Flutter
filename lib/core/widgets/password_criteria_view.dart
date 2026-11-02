import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/validators.dart';

class PasswordCriteriaView extends StatelessWidget {
  final String password;

  const PasswordCriteriaView({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final state = Validators.checkPasswordCriteria(password);
    final color = _getStrengthColor(state.strength);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Password Strength',
                style: AppTextStyles.labelMedium,
              ),
              Text(
                state.strengthLabel,
                key: const Key('password_strength_label'),
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final isFilled = index < state.metCount;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? color : AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          _CriterionRow(
            key: const Key('criterion_min_length'),
            isMet: state.hasMinLength,
            label: 'At least 8 characters',
          ),
          const SizedBox(height: 6),
          _CriterionRow(
            key: const Key('criterion_uppercase'),
            isMet: state.hasUppercase,
            label: 'At least one uppercase letter (A-Z)',
          ),
          const SizedBox(height: 6),
          _CriterionRow(
            key: const Key('criterion_lowercase'),
            isMet: state.hasLowercase,
            label: 'At least one lowercase letter (a-z)',
          ),
          const SizedBox(height: 6),
          _CriterionRow(
            key: const Key('criterion_digit'),
            isMet: state.hasDigit,
            label: 'At least one number (0-9)',
          ),
          const SizedBox(height: 6),
          _CriterionRow(
            key: const Key('criterion_special_char'),
            isMet: state.hasSpecialChar,
            label: 'At least one special character (!@#\$%^&*)',
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.warning;
      case PasswordStrength.strong:
        return AppColors.success;
    }
  }
}

class _CriterionRow extends StatelessWidget {
  final bool isMet;
  final String label;

  const _CriterionRow({
    super.key,
    required this.isMet,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          isMet ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
          color: isMet ? AppColors.success : AppColors.textMuted,
          size: 13,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: isMet
                ? AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  )
                : AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
          ),
        ),
      ],
    );
  }
}

