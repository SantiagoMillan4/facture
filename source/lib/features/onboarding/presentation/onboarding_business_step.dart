import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../../business/application/business_profile_providers.dart';
import '../../business/domain/business_profile.dart';

/// Onboarding step 2: the minimum business identity an invoice needs.
/// Name and an explicit tax-status choice are required; everything else
/// (address, contact, tax numbers, logo) can be added later in Settings.
///
/// The tax status starts unselected on purpose: this is the moment the
/// user declares it, so the app never has to assume a default.
class OnboardingBusinessStep extends ConsumerStatefulWidget {
  const OnboardingBusinessStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  ConsumerState<OnboardingBusinessStep> createState() =>
      _OnboardingBusinessStepState();
}

class _OnboardingBusinessStepState
    extends ConsumerState<OnboardingBusinessStep> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  TaxRegistrationStatus? _taxStatus;
  var _taxError = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final nameValid = _formKey.currentState!.validate();
    setState(() => _taxError = _taxStatus == null);
    if (!nameValid || _taxStatus == null) return;
    setState(() => _saving = true);
    AppHaptics.confirm();
    await ref
        .read(businessProfileProvider.notifier)
        .saveProfile(
          BusinessProfile(
            name: _nameController.text.trim(),
            taxStatus: _taxStatus!,
          ),
        );
    if (mounted) widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboardingBusinessTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.onboardingBusinessSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                  Text(
                    l10n.businessTaxStatusLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SegmentedButton<TaxRegistrationStatus>(
                    emptySelectionAllowed: true,
                    segments: [
                      ButtonSegment(
                        value: TaxRegistrationStatus.registered,
                        label: Text(l10n.businessTaxStatusRegistered),
                      ),
                      ButtonSegment(
                        value: TaxRegistrationStatus.smallSupplier,
                        label: Text(l10n.businessTaxStatusSmallSupplier),
                      ),
                    ],
                    selected: _taxStatus == null
                        ? const <TaxRegistrationStatus>{}
                        : {_taxStatus!},
                    onSelectionChanged: (selection) => setState(() {
                      // emptySelectionAllowed lets the user deselect; an
                      // empty set means "no choice yet", not a crash.
                      _taxStatus = selection.isEmpty
                          ? null
                          : selection.first;
                      _taxError = false;
                    }),
                  ),
                  if (_taxError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        l10n.onboardingTaxRequired,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.businessTaxStatusHelper,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _saving ? null : _continue,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.onboardingBusinessContinue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
