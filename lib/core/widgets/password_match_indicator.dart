import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class PasswordMatchIndicator extends StatelessWidget {
  final bool isMatching;

  const PasswordMatchIndicator({
    super.key,
    required this.isMatching,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMatching ? AppColors.success : AppColors.error;
    final icon = isMatching
        ? FontAwesomeIcons.circleCheck
        : FontAwesomeIcons.circleXmark;
    final text = isMatching ? 'Passwords match' : 'Passwords do not match';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMatching ? AppColors.successLight : AppColors.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMatching
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: color,
            size: 13,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              key: const Key('password_match_text'),
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

