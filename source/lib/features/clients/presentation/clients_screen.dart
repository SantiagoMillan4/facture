import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/adaptive_action_sheet.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/big_add_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../../shared/widgets/swipe_to_delete_tile.dart';
import '../application/clients_providers.dart';
import '../domain/client.dart';
import '../domain/client_sort.dart';
import 'client_avatar.dart';
import 'client_edit_screen.dart';

/// The client directory: who the freelancer bills.
///
/// Clients persist on-device only (local-first). The search field filters by
/// name, email or phone; the sort button opens a native action sheet with
/// name/recency orders (persisted). Tapping a row edits the client; swiping
/// left reveals Delete with a confirmation dialog.
class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  static const _sortPrefsKey = 'facture.clients_sort.v1';

  final _searchController = TextEditingController();
  String _query = '';
  ClientSort _sort = ClientSort.nameAsc;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSort();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query != _query) setState(() => _query = query);
  }

  Future<void> _loadSort() async {
    final prefs = await SharedPreferences.getInstance();
    final sort = ClientSort.fromStorageKey(prefs.getString(_sortPrefsKey));
    if (mounted && sort != _sort) setState(() => _sort = sort);
  }

  Future<void> _changeSort(ClientSort sort) async {
    if (sort == _sort) return;
    setState(() => _sort = sort);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortPrefsKey, sort.storageKey);
  }

  void _openEditor([Client? client]) {
    pushAppPage(context, (_) => ClientEditScreen(client: client));
  }

  Future<void> _showSortSheet() async {
    final l10n = context.l10n;
    final labels = {
      ClientSort.nameAsc: l10n.clientsSortNameAsc,
      ClientSort.nameDesc: l10n.clientsSortNameDesc,
      ClientSort.newestFirst: l10n.clientsSortNewest,
      ClientSort.oldestFirst: l10n.clientsSortOldest,
    };
    final selected = await showAdaptiveActionSheet<ClientSort>(
      context,
      title: l10n.clientsSortTitle,
      options: [
        for (final sort in ClientSort.values)
          ActionSheetOption(
            value: sort,
            label: labels[sort]!,
            icon: sort == _sort ? Icons.check : null,
          ),
      ],
    );
    if (selected != null) await _changeSort(selected);
  }

  bool _matchesQuery(Client client) {
    if (_query.isEmpty) return true;
    return client.name.toLowerCase().contains(_query) ||
        client.email.toLowerCase().contains(_query) ||
        client.phone.toLowerCase().contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navClients)),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (clients) {
          final visible = clients.where(_matchesQuery).toList()
            ..sort(_sort.compare);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: l10n.clientsSearchHint,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: l10n.clientsSearchClear,
                                  icon: const Icon(Icons.clear),
                                  onPressed: _searchController.clear,
                                ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(28),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filledTonal(
                      tooltip: l10n.clientsSortBy,
                      icon: const Icon(Icons.sort),
                      onPressed: _showSortSheet,
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildList(context, visible)),
              // Pinned above the tab bar, Rentable-style: the list scrolls
              // above it so the primary action is always within thumb reach.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: BigAddButton(
                  key: const ValueKey('addClientButton'),
                  label: l10n.clientsAddClient,
                  icon: Icons.person_add_outlined,
                  onPressed: () => _openEditor(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Client> visible) {
    final l10n = context.l10n;
    if (visible.isEmpty) {
      return _query.isEmpty
          ? EmptyState(
              icon: Icons.people_outline,
              title: l10n.clientsEmptyTitle,
              message: l10n.clientsEmptyMessage,
            )
          : EmptyState(
              icon: Icons.search_off,
              title: l10n.clientsNoResultsTitle,
              message: l10n.clientsNoResultsMessage,
            );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final client = visible[index];
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
            onDelete: () =>
                ref.read(clientsProvider.notifier).deleteClient(client.id),
            child: ListTile(
              leading: ClientAvatar(name: client.name),
              title: Text(client.name),
              subtitle: subtitle.isEmpty ? null : Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openEditor(client),
            ),
          ),
        );
      },
    );
  }
}
