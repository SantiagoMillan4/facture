import 'package:flutter/material.dart';

import '../application/onboarding_service.dart';
import 'onboarding_business_step.dart';
import 'onboarding_how_it_works_step.dart';
import 'onboarding_pricing_step.dart';
import 'onboarding_welcome_step.dart';

/// First-launch onboarding: welcome → business setup → how it works →
/// pricing. Forward-only; each step advances via its own callback and the
/// pricing step finishes the flow (marking it done so it never shows again).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var _step = 0;

  Future<void> _finish() async {
    await OnboardingService.markDone();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    // SizedBox.expand: this sits under an AnimatedSwitcher whose Stack
    // lays children out with loose constraints — the steps must fill.
    return SizedBox.expand(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: switch (_step) {
            0 => OnboardingWelcomeStep(
              onGetStarted: () => setState(() => _step = 1),
            ),
            1 => OnboardingBusinessStep(
              onContinue: () => setState(() => _step = 2),
            ),
            2 => OnboardingHowItWorksStep(
              onNext: () => setState(() => _step = 3),
            ),
            _ => OnboardingPricingStep(onFinish: _finish),
          },
        ),
      ),
    );
  }
}
