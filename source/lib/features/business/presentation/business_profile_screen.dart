import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/labeled_choice_field.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../application/business_profile_providers.dart';
import '../domain/business_profile.dart';

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

class _BusinessProfileScreenState
    extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _tpsController;
  late final TextEditingController _tvqController;
  late TaxRegistrationStatus _taxStatus;
  var _saving = false;

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
    _taxStatus =
        profile?.taxStatus ?? TaxRegistrationStatus.registered;
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
                label: l10n.businessNameLabel,
                hint: l10n.businessNameHint,
                autofocus: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
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
                onChanged: (s) => setState(() => _taxStatus = s),
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
