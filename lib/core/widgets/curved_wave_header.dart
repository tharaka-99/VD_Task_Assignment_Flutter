import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';

/// A modern dual-layer curved wave header for auth and landing screens.
///
/// Features a background translucent wave and a foreground primary gradient wave
/// crafted using Bézier curves to give a clean 3D fluid feel.
class CurvedWaveHeader extends StatelessWidget {
  final double height;
  final VoidCallback? onBackPressed;
  final Widget? trailing;

  const CurvedWaveHeader({
    super.key,
    this.height = 150.0,
    this.onBackPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Back Wave (Translucent Secondary Accent)
          ClipPath(
            clipper: const BackCurvedWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.38),
                    AppColors.primaryLight.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          // Layer 2: Front Wave (Vibrant Primary Brand Gradient)
          ClipPath(
            clipper: const FrontCurvedWaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryHover,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Ambient glowing orb 1 (top-right)
                  Positioned(
                    top: -30,
                    right: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  // Ambient glowing orb 2 (center-right)
                  Positioned(
                    top: 20,
                    right: 80,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                
                ],
              ),
            ),
          ),

          // Layer 3: Controls (Back button & Trailing action)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onBackPressed != null)
                    AuthBackButton(
                      onPressed: onBackPressed!,
                      onWave: true,
                    )
                  else
                    const SizedBox.shrink(),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clipper for the back/secondary wave layer
class BackCurvedWaveClipper extends CustomClipper<Path> {
  const BackCurvedWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.88);

    // Wave 1: Gentle curve rising towards the center
    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.68);
    final firstEndPoint = Offset(size.width * 0.52, size.height * 0.85);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Wave 2: Dips down gracefully on the right
    final secondControlPoint = Offset(size.width * 0.78, size.height * 1.04);
    final secondEndPoint = Offset(size.width, size.height * 0.72);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper for the front/primary wave layer
class FrontCurvedWaveClipper extends CustomClipper<Path> {
  const FrontCurvedWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.78);

    // Wave 1: Dips lower near center-left
    final firstControlPoint = Offset(size.width * 0.32, size.height * 1.02);
    final firstEndPoint = Offset(size.width * 0.62, size.height * 0.76);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Wave 2: Curves up elegantly towards right
    final secondControlPoint = Offset(size.width * 0.86, size.height * 0.56);
    final secondEndPoint = Offset(size.width, size.height * 0.82);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Reusable circular back button for auth layouts.
class AuthBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool onWave;

  const AuthBackButton({
    super.key,
    required this.onPressed,
    this.onWave = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: InkWell(
        key: const Key('auth_back_button'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onWave ? Colors.white : AppColors.background,
            border: Border.all(
              color: onWave
                  ? Colors.white.withValues(alpha: 0.3)
                  : AppColors.cardBorder,
            ),
            boxShadow: onWave
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 16,
              color: onWave ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

