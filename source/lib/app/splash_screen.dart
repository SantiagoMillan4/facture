import 'package:flutter/material.dart';

import '../shared/theme/app_motion.dart';

/// In-app animated splash shown after the native launch screen.
///
/// The native splash is a plain brand background (teal / near-black green),
/// which hands off seamlessly into this screen: same background, then the
/// logo fades/scales in centered and the "Facture" wordmark fades in below.
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
  // Sampled from the logo corners so the artwork blends into the
  // background. Must match the flutter_native_splash colors exactly.
  static const _bgLight = Color(0xFF0D6F6C);
  static const _bgDark = Color(0xFF091717);
  static const _logoLight = 'assets/brand/app_icon.png';
  static const _logoDark = 'assets/brand/app_icon_dark.png';

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

    final logoIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: AppMotion.entranceCurve),
    );
    final wordmarkIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.8, curve: AppMotion.entranceCurve),
    );

    return GestureDetector(
      onTap: _notifyReady,
      behavior: HitTestBehavior.opaque,
      // NOTE: do NOT use Scaffold(body: Stack(alignment: center)) here.
      // Scaffold layers its body inside an internal Stack with loose
      // constraints, so an inner Stack shrink-wraps to its child and sticks
      // to the top-left (the logo rendered there instead of centered).
      // ColoredBox fills the screen; the inner Stack then truly centers.
      child: ColoredBox(
        color: dark ? _bgDark : _bgLight,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity: logoIn,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(logoIn),
                  child: Image.asset(
                    dark ? _logoDark : _logoLight,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.sizeOf(context).height * 0.30,
                child: FadeTransition(
                  opacity: wordmarkIn,
                  child: const Text(
                    'Facture',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
