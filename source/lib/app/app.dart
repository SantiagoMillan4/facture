import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/clients/presentation/clients_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/invoices/presentation/invoices_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_localizations.dart';
import '../shared/theme/app_theme.dart';

/// Index of the bottom-navigation tab. A provider (rather than local state)
/// so a pushed page can switch tabs — e.g. jumping to Invoices after
/// creating one.
final homeTabIndexProvider = StateProvider<int>((ref) => 0);

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
        home: const HomeShell(),
      ),
    );
  }
}

/// Bottom-tab shell: Dashboard, Invoices, Settings. Each tab owns its app
/// bar; tab switches use a short crossfade.
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
          ref.read(homeTabIndexProvider.notifier).state = index;
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: l10n.navDashboard,
          ),
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
      0 => const DashboardScreen(),
      1 => const InvoicesScreen(),
      2 => const ClientsScreen(),
      _ => const SettingsScreen(),
    };
  }
}
