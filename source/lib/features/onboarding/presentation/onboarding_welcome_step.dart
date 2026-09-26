import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';

/// Onboarding step 1: brand moment. Full-bleed brand background (the same
/// teal as the splash), logo, wordmark, tagline, and the Get Started
/// button pinned near the bottom.
class OnboardingWelcomeStep extends StatelessWidget {
  const OnboardingWelcomeStep({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  static const _bgLight = Color(0xFF0D6F6C);
  static const _bgDark = Color(0xFF091717);
  static const _logoLight = 'assets/brand/splash_logo.png';
  static const _logoDark = 'assets/brand/splash_logo_dark.png';

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    final onBrand = dark ? _bgDark : _bgLight;
    return ColoredBox(
      color: onBrand,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        dark ? _logoDark : _logoLight,
                        width: 140,
                        height: 140,
                        errorBuilder: (_, _, _) =>
                            const SizedBox(width: 140, height: 140),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text(
                        'Facture',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.onboardingTagline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: onBrand,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: onGetStarted,
                  child: Text(l10n.onboardingGetStarted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
