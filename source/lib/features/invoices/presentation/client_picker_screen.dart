import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../clients/application/clients_providers.dart';
import '../../clients/domain/client.dart';
import '../../clients/presentation/client_edit_screen.dart';

/// Picks a client for an invoice. Tapping a client returns it via
/// `Navigator.pop`; the "New client" action creates one first and
/// returns it immediately.
class ClientPickerScreen extends ConsumerWidget {
  const ClientPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.invoiceSelectClient),
        actions: [
          TextButton(
            onPressed: () => _createClient(context, ref),
            child: Text(l10n.invoiceNewClient),
          ),
        ],
      ),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (clients) {
          if (clients.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: l10n.clientsEmptyTitle,
              message: l10n.clientsEmptyMessage,
              actionLabel: l10n.invoiceNewClient,
              onAction: () => _createClient(context, ref),
            );
          }
          final sorted = List<Client>.of(clients)
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
          return ListView.separated(
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final client = sorted[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    client.name.isNotEmpty
                        ? client.name.characters.first.toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(client.name),
                subtitle: client.email.isNotEmpty
                    ? Text(client.email)
                    : null,
                onTap: () => Navigator.of(context).pop(client),
              );
            },
          );
        },
      ),
    );
  }

  /// Opens the client editor for a brand-new client; on save, the created
  /// client is returned to the invoice form.
  Future<void> _createClient(BuildContext context, WidgetRef ref) async {
    final id = newClientId();
    await pushAppPage<void>(
      context,
      (_) => ClientEditScreen(client: Client(id: id, name: '')),
    );
    if (!context.mounted) return;
    final created =
        ref.read(clientsProvider).value?.where((c) => c.id == id).firstOrNull;
    if (created != null) {
      Navigator.of(context).pop(created);
    }
  }
}
