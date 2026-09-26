import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/clients/presentation/clients_screen.dart';
import '../features/invoices/presentation/invoice_form_screen.dart';
import '../features/invoices/presentation/invoices_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tools/presentation/tools_screen.dart';
import '../features/purchase/application/purchase_providers.dart';
import '../features/purchase/presentation/paywall_sheet.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_localizations.dart';
import '../shared/theme/app_motion.dart';
import '../shared/theme/app_spacing.dart';
import '../shared/theme/app_theme.dart';
import '../shared/widgets/app_page_route.dart';
import 'splash_screen.dart';

/// Index of the bottom-navigation tab. A provider (rather than local state)
/// so a pushed page can switch tabs — e.g. jumping to Invoices after
/// creating one.
final homeTabIndexProvider =
    NotifierProvider<HomeTabIndexNotifier, int>(HomeTabIndexNotifier.new);

class HomeTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

/// Root widget: Riverpod scope, Material 3 theme (light/dark), and
/// EN/Québec-French localization with English fallback.
///
/// French-first: the device locale resolves to French whenever the device
/// prefers it; anything else falls back to English.
class FactureApp extends StatelessWidget {
  const FactureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Facture',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, supported) {
          for (final locale in locales ?? const <Locale>[]) {
            if (locale.languageCode == 'fr') return const Locale('fr');
            if (locale.languageCode == 'en') return const Locale('en');
          }
          return const Locale('en');
        },
        home: const _SplashGate(),
      ),
    );
  }
}

/// Shows the animated splash first, then crossfades into the tab shell.
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  var _ready = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppMotion.pageTransition,
      child: _ready
          ? const HomeShell()
          : SplashScreen(onReady: () => setState(() => _ready = true)),
    );
  }
}

/// Bottom-tab shell: Invoices, Clients, Tools, Settings, with a prominent
/// "New invoice" button in the middle. Each tab owns its app bar; tab
/// switches use a short crossfade.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  /// Opens the invoice form, or the paywall once the free tier is used up.
  void _newInvoice(BuildContext context, WidgetRef ref) {
    if (ref.read(canCreateInvoiceProvider)) {
      pushAppPage(context, (_) => const InvoiceFormScreen());
    } else {
      showPaywallSheet(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(homeTabIndexProvider);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(selectedIndex),
          child: _screenForIndex(selectedIndex),
        ),
      ),
      bottomNavigationBar: _BottomBar(
        selectedIndex: selectedIndex,
        onSelect: (index) =>
            ref.read(homeTabIndexProvider.notifier).select(index),
        onNewInvoice: () => _newInvoice(context, ref),
      ),
    );
  }

  Widget _screenForIndex(int index) {
    return switch (index) {
      0 => const InvoicesScreen(),
      1 => const ClientsScreen(),
      2 => const ToolsScreen(),
      _ => const SettingsScreen(),
    };
  }
}

/// Custom bottom bar: four tab destinations with a big "New invoice"
/// button in the middle.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onNewInvoice,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onNewInvoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _TabButton(
              key: const ValueKey('navTab0'),
              icon: Icons.receipt_long_outlined,
              selectedIcon: Icons.receipt_long_rounded,
              label: l10n.navInvoices,
              selected: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
            _TabButton(
              key: const ValueKey('navTab1'),
              icon: Icons.people_outline,
              selectedIcon: Icons.people_rounded,
              label: l10n.navClients,
              selected: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                ),
                child: FilledButton.icon(
                  key: const ValueKey('newInvoiceButton'),
                  onPressed: onNewInvoice,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newInvoice),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),
            ),
            _TabButton(
              key: const ValueKey('navTab2'),
              icon: Icons.handyman_outlined,
              selectedIcon: Icons.handyman_rounded,
              label: l10n.navTools,
              selected: selectedIndex == 2,
              onTap: () => onSelect(2),
            ),
            _TabButton(
              key: const ValueKey('navTab3'),
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_rounded,
              label: l10n.navSettings,
              selected: selectedIndex == 3,
              onTap: () => onSelect(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? selectedIcon : icon, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
