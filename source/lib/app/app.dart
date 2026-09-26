import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/clients/presentation/clients_screen.dart';
import '../features/invoices/presentation/invoices_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tools/presentation/tools_screen.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_localizations.dart';
import '../shared/theme/app_motion.dart';
import '../shared/theme/app_theme.dart';
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

/// Bottom-tab shell: Invoices, Clients, Tools, Settings. Each tab owns
/// its app bar; tab switches use a short crossfade. The primary "add"
/// actions live on their pages as big buttons, not in the tab bar.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(homeTabIndexProvider);
    final l10n = context.l10n;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(selectedIndex),
          child: _screenForIndex(selectedIndex),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(homeTabIndexProvider.notifier).select(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: l10n.navInvoices,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people_rounded),
            label: l10n.navClients,
          ),
          NavigationDestination(
            icon: const Icon(Icons.handyman_outlined),
            selectedIcon: const Icon(Icons.handyman_rounded),
            label: l10n.navTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
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
