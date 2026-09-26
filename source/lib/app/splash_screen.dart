import 'package:flutter/material.dart';

import '../shared/theme/app_motion.dart';
import '../shared/theme/app_spacing.dart';

/// In-app animated splash shown after the native launch screen.
///
/// The native splash is a plain brand background (teal / near-black green),
/// which hands off seamlessly into this screen: the logo fades/scales in,
/// then the "Facture" wordmark fades in right below it. Same structure and
/// timing as Rentable's splash.
/// Tapping skips immediately; reduced-motion shows the final frame at once.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onReady});

  /// The entrance completed (or was skipped): the splash has shown for its
  /// minimum brand moment.
  final VoidCallback onReady;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Backgrounds must match the flutter_native_splash colors exactly.
  // The splash logo assets are full-bleed on these backgrounds, so their
  // square edges are invisible.
  static const _bgLight = Color(0xFF0D6F6C);
  static const _bgDark = Color(0xFF091717);
  static const _logoLight = 'assets/brand/splash_logo.png';
  static const _logoDark = 'assets/brand/splash_logo_dark.png';

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.splashMin,
  );
  var _started = false;
  var _readySent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.animationsEnabled(context)) {
      // The running ticker keeps frames scheduled, so the splash stays
      // for its full brand moment even under test harnesses.
      _controller.forward().whenCompleteOrCancel(_notifyReady);
    } else {
      _controller.value = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifyReady());
    }
  }

  void _notifyReady() {
    if (_readySent || !mounted) return;
    _readySent = true;
    widget.onReady();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final logo = FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.55, curve: AppMotion.entranceCurve),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.55, curve: AppMotion.entranceCurve),
          ),
        ),
        // The asset is full-bleed on the matching background, so its square
        // edges are invisible.
        child: Image.asset(
          dark ? _logoDark : _logoLight,
          width: 120,
          height: 120,
          errorBuilder: (_, _, _) => const SizedBox(width: 120, height: 120),
        ),
      ),
    );

    final wordmark = FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.7, curve: AppMotion.entranceCurve),
      ),
      child: const Text(
        'Facture',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          // Defensive: the wordmark must never render an underline, no
          // matter what text decorations the ambient theme may carry.
          decoration: TextDecoration.none,
        ),
      ),
    );

    // NOTE: this splash is a direct child of an AnimatedSwitcher, whose
    // Stack lays children out with LOOSE constraints. Center expands under
    // loose constraints (Stack/Scaffold.body do not), which is what keeps
    // the background full-screen. Same recipe as Rentable's splash; do not
    // "simplify" this back to Scaffold+Stack.
    return GestureDetector(
      onTap: _notifyReady,
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: dark ? _bgDark : _bgLight,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                logo,
                const SizedBox(height: AppSpacing.xl),
                wordmark,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
