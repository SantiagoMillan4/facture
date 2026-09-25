import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_spacing.dart';
import '../application/purchase_providers.dart';
import '../domain/purchase_catalog.dart';

/// Maps notifier notices to localized strings.
extension PurchaseNoticeL10n on AppLocalizations {
  String purchaseNotice(PurchaseNotice notice) {
    switch (notice) {
      case PurchaseNotice.unavailable:
        return proNoticeUnavailable;
      case PurchaseNotice.failed:
        return proNoticeFailed;
      case PurchaseNotice.restored:
        return proNoticeRestored;
      case PurchaseNotice.nothingToRestore:
        return proNoticeNothingToRestore;
    }
  }
}

/// Opens the Facture Pro paywall as a native-feeling sheet:
/// Cupertino popup on iOS/macOS, Material bottom sheet elsewhere.
Future<void> showPaywallSheet(BuildContext context) {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => const _PaywallSheetBody(),
    );
  }
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const _PaywallSheetBody(),
  );
}

class _PaywallSheetBody extends ConsumerWidget {
  const _PaywallSheetBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dismiss once the purchase completes.
    ref.listen(purchaseProvider, (previous, next) {
      final wasPro = previous?.valueOrNull?.isPro ?? false;
      final isPro = next.valueOrNull?.isPro ?? false;
      if (!wasPro && isPro && context.mounted) {
        Navigator.of(context).pop();
      }
    });

    final purchaseAsync = ref.watch(purchaseProvider);
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: purchaseAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            data: (state) => _PaywallContent(state: state),
          ),
        ),
      ),
    );
  }
}

class _PaywallContent extends ConsumerWidget {
  const _PaywallContent({required this.state});

  final PurchaseState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final notifier = ref.read(purchaseProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer,
          ),
          child: Icon(
            Icons.workspace_premium_outlined,
            size: 32,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.proTitle,
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.proSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        _FeatureRow(icon: Icons.all_inclusive, label: l10n.proFeatureUnlimited),
        _FeatureRow(
          icon: Icons.payments_outlined,
          label: l10n.proFeatureOneTime,
        ),
        _FeatureRow(
          icon: Icons.block_outlined,
          label: l10n.proFeatureNoSubscription,
        ),
        if (!state.isPro) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.proFreeLimit(
              ref.watch(invoiceCountProvider),
              PurchaseCatalog.freeInvoiceLimit,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (state.notice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              l10n.purchaseNotice(state.notice!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: state.noticeIsError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (state.isPro)
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check),
            label: Text(l10n.proActive),
          )
        else if (state.product == null && !state.isPurchasing)
          Text(
            l10n.proNoticeUnavailable,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          )
        else
          FilledButton(
            onPressed:
                state.isPurchasing ? null : () => notifier.buyPro(),
            child: state.isPurchasing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.proBuy(state.product?.price ?? '')),
          ),
        if (!state.isPro) ...[
          TextButton(
            onPressed:
                state.isPurchasing ? null : () => notifier.restorePurchases(),
            child: Text(
              state.isPurchasing ? l10n.proRestoring : l10n.proRestore,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.proFinePrint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
