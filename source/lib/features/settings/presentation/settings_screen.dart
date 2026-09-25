import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/form_section_title.dart';
import 'how_it_works_screen.dart';
import 'tax_explainer_screen.dart';

// TODO: replace with the real support address before the App Store release.
const _kFeedbackEmail = 'support@facture.app';

// Keep in sync with pubspec.yaml.
const _kAppVersion = '0.1.0';

/// Opens the mail app prefilled with a feedback email. When no mail app can
/// handle the link (canLaunchUrl is unreliable for mailto on iOS), falls
/// back to copying the support address to the clipboard so the user can
/// paste it into any mail app.
Future<void> _sendFeedback(BuildContext context) async {
  final uri = Uri(
    scheme: 'mailto',
    path: _kFeedbackEmail,
    queryParameters: {'subject': context.l10n.feedbackEmailSubject(_kAppVersion)},
  );
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!context.mounted) return;
  if (opened) return;
  await Clipboard.setData(const ClipboardData(text: _kFeedbackEmail));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(context.l10n.feedbackEmailCopied)),
  );
}

/// Asks the OS to show its native in-app review prompt. Best-effort: the OS
/// throttles review prompts and may decline, which we silently ignore.
Future<void> _requestAppReview() async {
  try {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  } catch (_) {
    // Review prompts are best-effort; never block the user on failure.
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          FormSectionTitle(title: l10n.settingsLearn),
          _SettingsTile(
            icon: Icons.school_outlined,
            title: l10n.howItWorks,
            subtitle: l10n.howItWorksSubtitle,
            onTap: () => pushAppPage(context, (_) => const HowItWorksScreen()),
          ),
          _SettingsTile(
            icon: Icons.percent_outlined,
            title: l10n.tpsTvqTitle,
            subtitle: l10n.tpsTvqSubtitle,
            onTap: () => pushAppPage(context, (_) => const TaxExplainerScreen()),
          ),
          FormSectionTitle(title: l10n.toolsSection),
          _SettingsTile(
            icon: Icons.handyman_outlined,
            title: l10n.toolsComingSoon,
            subtitle: '',
          ),
          FormSectionTitle(title: l10n.settingsAbout),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: l10n.feedbackTitle,
            subtitle: l10n.feedbackSubtitle,
            onTap: () => _sendFeedback(context),
          ),
          _SettingsTile(
            icon: Icons.star_outline,
            title: l10n.rateAppTitle,
            subtitle: l10n.rateAppSubtitle,
            onTap: _requestAppReview,
          ),
          const _BrandTile(),
        ],
      ),
    );
  }
}

/// About row showing the app name and version.
class _BrandTile extends StatelessWidget {
  const _BrandTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Facture',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.versionLabel(_kAppVersion),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
