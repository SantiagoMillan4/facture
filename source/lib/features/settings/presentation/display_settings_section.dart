import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/adaptive_action_sheet.dart';
import '../../../shared/widgets/form_section_title.dart';
import '../application/display_settings.dart';

/// Settings section letting the user override the device language and
/// theme. Both default to following the device; a choice here wins.
class DisplaySettingsSection extends ConsumerWidget {
  const DisplaySettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final localeOverride = ref.watch(localeOverrideProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSectionTitle(title: l10n.settingsAppearance, isFirst: true),
        _ChoiceTile(
          icon: Icons.language_outlined,
          title: l10n.settingsLanguage,
          value: _localeLabel(localeOverride, l10n),
          onTap: () => _pickLocale(context, ref),
        ),
        _ChoiceTile(
          icon: Icons.dark_mode_outlined,
          title: l10n.settingsTheme,
          value: _themeLabel(themeMode, l10n),
          onTap: () => _pickTheme(context, ref),
        ),
      ],
    );
  }

  String _localeLabel(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.settingsSystemDefault;
    // Language names stay in their own language, the usual convention.
    return locale.languageCode == 'fr' ? 'Français' : 'English';
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.system => l10n.settingsSystemDefault,
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
    };
  }

  /// The sheet returns the chosen code ('system', 'en', 'fr'), or null when
  /// dismissed. 'system' is a real value here, so the sentinel must be a
  /// non-nullable code rather than a nullable Locale.
  Future<void> _pickLocale(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final choice = await showAdaptiveActionSheet<String>(
      context,
      title: l10n.settingsLanguage,
      options: [
        ActionSheetOption(value: 'system', label: l10n.settingsSystemDefault),
        const ActionSheetOption(value: 'en', label: 'English'),
        const ActionSheetOption(value: 'fr', label: 'Français'),
      ],
    );
    if (choice == null || !context.mounted) return;
    final locale = choice == 'system' ? null : Locale(choice);
    await DisplaySettingsService.saveLocale(locale);
    ref.read(localeOverrideProvider.notifier).set(locale);
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final choice = await showAdaptiveActionSheet<String>(
      context,
      title: l10n.settingsTheme,
      options: [
        ActionSheetOption(value: 'system', label: l10n.settingsSystemDefault),
        ActionSheetOption(value: 'light', label: l10n.settingsThemeLight),
        ActionSheetOption(value: 'dark', label: l10n.settingsThemeDark),
      ],
    );
    if (choice == null || !context.mounted) return;
    final mode = ThemeMode.values.firstWhere((m) => m.name == choice);
    await DisplaySettingsService.saveThemeMode(mode);
    ref.read(themeModeProvider.notifier).set(mode);
  }
}

/// A settings row showing the current choice as its subtitle, mirroring the
/// style of the other settings tiles.
class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
