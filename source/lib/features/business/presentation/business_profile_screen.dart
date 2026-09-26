import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/labeled_choice_field.dart';
import '../../../shared/widgets/labeled_fields.dart';

import 'dart:typed_data';

import '../application/business_logo.dart';
import '../application/business_profile_providers.dart';
import '../domain/business_profile.dart';
import '../../logo/presentation/logo_creator_screen.dart';

/// The freelancer's own business identity: name, contact details, and an
/// explicit TPS/TVQ registration status.
///
/// The profile appears on invoice PDFs and drives the invoice form's tax
/// default (registered → taxes on, small supplier → taxes off). Stored
/// on-device only.
class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _tpsController;
  late final TextEditingController _tvqController;
  late TaxRegistrationStatus _taxStatus;
  String? _logoPath;
  Uint8List? _logoBytes;
  var _saving = false;
  // Whether the user explicitly picked a tax status in this form session.
  // Used to avoid clobbering an explicit choice when the logo creator
  // creates the underlying profile (see _createLogo).
  var _taxStatusTouched = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(businessProfileProvider).value;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _tpsController = TextEditingController(text: profile?.tpsNumber ?? '');
    _tvqController = TextEditingController(text: profile?.tvqNumber ?? '');
    _taxStatus = profile?.taxStatus ?? TaxRegistrationStatus.registered;
    _logoPath = profile?.logoPath;
    _loadLogoBytes();
  }

  Future<void> _loadLogoBytes() async {
    final bytes = await BusinessLogo.readBytes(_logoPath);
    if (mounted) setState(() => _logoBytes = bytes);
  }

  Future<void> _pickLogo() async {
    final path = await BusinessLogo.pickAndStore();
    if (path == null || !mounted) return;
    // pickAndStore writes to a fixed filename, so a repeat pick overwrites
    // the previous file in place: only delete when the path changed,
    // otherwise we'd delete the copy we just made.
    if (path != _logoPath) await BusinessLogo.delete(_logoPath);
    setState(() => _logoPath = path);
    await _loadLogoBytes();
  }

  /// Opens the in-app logo creator. It persists the generated logo itself;
  /// this screen just adopts the returned path into its draft.
  Future<void> _createLogo() async {
    // The creator creates a small-supplier profile when none exists yet.
    // If it does, the tax status this form initialized with (registered by
    // default) is stale: adopt the profile's status so a later form save
    // can't silently switch taxes on. An explicit user choice always wins,
    // and draft name/contact fields are never touched.
    final hadProfile = ref.read(businessProfileProvider).value != null;
    final path = await pushAppPage<String>(
      context,
      (_) => LogoCreatorScreen(initialName: _nameController.text),
    );
    if (path == null || !mounted) return;
    if (!hadProfile && !_taxStatusTouched) {
      final profile = ref.read(businessProfileProvider).value;
      if (profile != null) {
        setState(() => _taxStatus = profile.taxStatus);
      }
    }
    setState(() => _logoPath = path);
    await _loadLogoBytes();
  }

  Future<void> _removeLogo() async {
    await BusinessLogo.delete(_logoPath);
    if (mounted) {
      setState(() {
        _logoPath = null;
        _logoBytes = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _tpsController.dispose();
    _tvqController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final registered = _taxStatus == TaxRegistrationStatus.registered;
    final profile = BusinessProfile(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      taxStatus: _taxStatus,
      tpsNumber: registered ? _tpsController.text.trim() : '',
      tvqNumber: registered ? _tvqController.text.trim() : '',
      logoPath: _logoPath,
    );
    AppHaptics.confirm();
    await ref.read(businessProfileProvider.notifier).saveProfile(profile);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final registered = _taxStatus == TaxRegistrationStatus.registered;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.businessProfileTitle),
        actions: [
          TextButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
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
              _LogoTile(
                logoBytes: _logoBytes,
                hasLogo: _logoPath != null,
                onPick: _pickLogo,
                onRemove: _removeLogo,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _createLogo,
                  child: Text(l10n.businessLogoCreate),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              LabeledTextField(
                controller: _nameController,
                label: l10n.businessNameLabel,
                hint: l10n.businessNameHint,
                autofocus: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.businessNameRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _addressController,
                label: l10n.businessAddressLabel,
                hint: l10n.businessAddressHint,
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      controller: _phoneController,
                      label: l10n.businessPhoneLabel,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: LabeledTextField(
                      controller: _emailController,
                      label: l10n.businessEmailLabel,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              LabeledChoiceField<TaxRegistrationStatus>(
                label: l10n.businessTaxStatusLabel,
                selected: _taxStatus,
                onChanged: (s) => setState(() {
                  _taxStatus = s;
                  _taxStatusTouched = true;
                }),
                helper: l10n.businessTaxStatusHelper,
                options: [
                  ChoiceOption(
                    value: TaxRegistrationStatus.registered,
                    label: l10n.businessTaxStatusRegistered,
                    sublabel: l10n.businessTaxStatusRegisteredSub,
                  ),
                  ChoiceOption(
                    value: TaxRegistrationStatus.smallSupplier,
                    label: l10n.businessTaxStatusSmallSupplier,
                    sublabel: l10n.businessTaxStatusSmallSupplierSub,
                  ),
                ],
              ),
              if (registered) ...[
                LabeledTextField(
                  controller: _tpsController,
                  label: l10n.businessTpsNumberLabel,
                  hint: l10n.businessTpsNumberHint,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                LabeledTextField(
                  controller: _tvqController,
                  label: l10n.businessTvqNumberLabel,
                  hint: l10n.businessTvqNumberHint,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.businessDisclaimer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo picker row: thumbnail (or placeholder), tap to choose, trash to
/// remove. The logo is shown on invoice PDFs.
class _LogoTile extends StatelessWidget {
  const _LogoTile({
    required this.logoBytes,
    required this.hasLogo,
    required this.onPick,
    required this.onRemove,
  });

  final Uint8List? logoBytes;
  final bool hasLogo;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bytes = logoBytes;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: bytes == null
              ? Container(
                  width: 52,
                  height: 52,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : Image.memory(bytes, width: 52, height: 52, fit: BoxFit.cover),
        ),
        title: Text(l10n.businessLogoLabel),
        subtitle: Text(l10n.businessLogoHint),
        trailing: hasLogo
            ? IconButton(
                tooltip: l10n.businessLogoRemove,
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
              )
            : const Icon(Icons.chevron_right),
        onTap: onPick,
      ),
    );
  }
}
