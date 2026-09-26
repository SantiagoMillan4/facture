import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../../shared/widgets/swipe_to_delete_tile.dart';
import '../application/clients_providers.dart';
import '../domain/client.dart';
import 'client_edit_screen.dart';

/// The client directory: who the freelancer bills.
///
/// Clients persist on-device only (local-first). Tapping a row edits the
/// client; swiping left reveals Delete with a confirmation dialog.
class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  void _openEditor(BuildContext context, [Client? client]) {
    pushAppPage(context, (_) => ClientEditScreen(client: client));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navClients)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip: l10n.clientsAddClient,
        child: const Icon(Icons.add),
      ),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (clients) {
          if (clients.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: l10n.clientsEmptyTitle,
              message: l10n.clientsEmptyMessage,
              actionLabel: l10n.clientsAddClient,
              onAction: () => _openEditor(context),
            );
          }
          final sorted = List<Client>.of(clients)
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: sorted.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final client = sorted[index];
              final subtitle = [
                if (client.email.isNotEmpty) client.email,
                if (client.phone.isNotEmpty) client.phone,
              ].join(' · ');
              return StaggeredEntrance(
                index: index,
                child: SwipeToDeleteTile(
                  confirmDelete: true,
                  deleteTitle: l10n.clientDeleteTitle,
                  deleteMessage: l10n.clientDeleteMessage(client.name),
                  onDelete: () => ref
                      .read(clientsProvider.notifier)
                      .deleteClient(client.id),
                  child: ListTile(
                    title: Text(client.name),
                    subtitle: subtitle.isEmpty ? null : Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openEditor(context, client),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
