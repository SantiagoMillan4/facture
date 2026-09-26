import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../purchase/application/purchase_providers.dart';
import '../../purchase/presentation/paywall_sheet.dart';

/// Onboarding step 4: the pricing decision. Pro is highlighted; the free
/// tier is an honest one-tap alternative, never a dead end.
///
/// Tapping "Get Facture Pro" opens the existing paywall sheet (purchase,
/// restore, and error handling live there). A completed purchase finishes
/// onboarding automatically.
class OnboardingPricingStep extends ConsumerWidget {
  const OnboardingPricingStep({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // A purchase completed from the paywall sheet finishes onboarding.
    ref.listen(purchaseProvider, (previous, next) {
      final wasPro = previous?.value?.isPro ?? false;
      final isPro = next.value?.isPro ?? false;
      if (!wasPro && isPro && context.mounted) onFinish();
    });

    final purchase = ref.watch(purchaseProvider).value;
    final isPro = purchase?.isPro ?? false;
    final price = purchase?.product?.price ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.onboardingPricingTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.onboardingPricingSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (isPro)
                FilledButton(
                  onPressed: onFinish,
                  child: Text(l10n.onboardingBusinessContinue),
                )
              else ...[
                _ProCard(
                  price: price,
                  onGetPro: () => showPaywallSheet(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _FreeCard(onStartFree: onFinish),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.price, required this.onGetPro});

  final String price;
  final VoidCallback onGetPro;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.proTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.onboardingProBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (price.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                price,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: onGetPro,
              child: Text(l10n.onboardingGetPro),
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  const _FreeCard({required this.onStartFree});

  final VoidCallback onStartFree;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.onboardingFreeTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.onboardingFreeBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onStartFree,
              child: Text(l10n.onboardingStartFree),
            ),
          ],
        ),
      ),
    );
  }
}
