import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'curved_wave_header.dart';

class ResponsiveAuthLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final String illustrationPath;
  final bool showIllustrationOnMobile;
  final VoidCallback? onBackPressed;

  const ResponsiveAuthLayout({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.illustrationPath = AppAssets.loginIllustration,
    this.showIllustrationOnMobile = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTwoPane = constraints.maxWidth >= 800;

          if (isTwoPane) {
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryHover,
                        ],
                      ),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                AppAssets.logo,
                                width: 56,
                                height: 56,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const FaIcon(
                                  FontAwesomeIcons.shieldHalved,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              title,
                              style: AppTextStyles.displayLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              subtitle,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Center(
                              child: SvgPicture.asset(
                                illustrationPath,
                                height: 200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onBackPressed != null) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: AuthBackButton(
                                    onPressed: onBackPressed!,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              child,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Single pane with dual-layer curved wave header for screens under 800px width
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CurvedWaveHeader(
                  height: 150,
                  onBackPressed: onBackPressed,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showIllustrationOnMobile) ...[
                            Center(
                              child: SvgPicture.asset(
                                illustrationPath,
                                height: 140,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          child,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
