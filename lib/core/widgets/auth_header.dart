import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              AppAssets.logo,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const FaIcon(
                FontAwesomeIcons.shieldHalved,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headingLarge,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}
