import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: FontAwesomeIcons.circleCheck,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: FontAwesomeIcons.circleExclamation,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final size = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomMargin =
        (size.height - topPadding - 72).clamp(0.0, double.infinity);
    final horizontalMargin = size.width > 600 ? (size.width - 440) / 2 : 16.0;

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
