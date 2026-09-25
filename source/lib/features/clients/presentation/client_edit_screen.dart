import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../application/clients_providers.dart';
import '../domain/client.dart';

/// Add / edit a client. `client` is null for a new client.
///
/// Name is required; everything else is optional. Saving persists the
/// whole directory on-device via [ClientsNotifier].
class ClientEditScreen extends ConsumerStatefulWidget {
  const ClientEditScreen({super.key, this.client});

  final Client? client;

  @override
  ConsumerState<ClientEditScreen> createState() => _ClientEditScreenState();
}

class _ClientEditScreenState extends ConsumerState<ClientEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final client = widget.client;
    _nameController = TextEditingController(text: client?.name ?? '');
    _emailController = TextEditingController(text: client?.email ?? '');
    _phoneController = TextEditingController(text: client?.phone ?? '');
    _addressController = TextEditingController(text: client?.address ?? '');
    _notesController = TextEditingController(text: client?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final existing = widget.client;
    final client = Client(
      id: existing?.id ?? newClientId(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      tpsNumber: existing?.tpsNumber,
      tvqNumber: existing?.tvqNumber,
    );
    AppHaptics.confirm();
    await ref.read(clientsProvider.notifier).saveClient(client);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client == null ? l10n.clientNewTitle : l10n.clientEditTitle,
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              LabeledTextField(
                controller: _nameController,
                label: l10n.clientNameLabel,
                autofocus: widget.client == null,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                    ? l10n.clientNameRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _emailController,
                label: l10n.clientEmailLabel,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _phoneController,
                label: l10n.clientPhoneLabel,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _addressController,
                label: l10n.clientAddressLabel,
                maxLines: 2,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _notesController,
                label: l10n.clientNotesLabel,
                hint: l10n.clientNotesHint,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
