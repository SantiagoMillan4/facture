import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/form_section_title.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../application/email_template_providers.dart';
import '../domain/email_template.dart';

/// Edits the subject/body template used when emailing an invoice.
///
/// Placeholders like `{invoice_number}` are replaced automatically when the
/// email opens; tapping one inserts it into the focused field. Stored
/// on-device only.
class EmailTemplateScreen extends ConsumerStatefulWidget {
  const EmailTemplateScreen({super.key});

  @override
  ConsumerState<EmailTemplateScreen> createState() =>
      _EmailTemplateScreenState();
}

class _EmailTemplateScreenState extends ConsumerState<EmailTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final TextEditingController _bodyController;
  final _subjectFocus = FocusNode();
  final _bodyFocus = FocusNode();

  /// The field that last had focus — tap-to-insert targets it.
  TextEditingController get _targetController =>
      _bodyFocus.hasFocus ? _bodyController : _subjectController;

  var _saving = false;

  @override
  void initState() {
    super.initState();
    // Controllers start empty; the template (or localized default) fills
    // them in didChangeDependencies, where Localizations is available.
    _subjectController = TextEditingController();
    _bodyController = TextEditingController();
  }

  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final template =
        ref.read(emailTemplateProvider).value ??
        EmailTemplate.defaults(french: context.isFrench);
    _subjectController.text = template.subject;
    _bodyController.text = template.body;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _subjectFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    AppHaptics.confirm();
    await ref
        .read(emailTemplateProvider.notifier)
        .saveTemplate(
          EmailTemplate(
            subject: _subjectController.text.trim(),
            body: _bodyController.text.trim(),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _resetToDefault() async {
    final defaults = EmailTemplate.defaults(french: context.isFrench);
    setState(() {
      _subjectController.text = defaults.subject;
      _bodyController.text = defaults.body;
    });
    AppHaptics.confirm();
    await ref.read(emailTemplateProvider.notifier).saveTemplate(defaults);
    if (mounted) Navigator.of(context).pop();
  }

  /// Inserts [placeholder] at the cursor of the last-focused field.
  void _insertPlaceholder(String placeholder) {
    final controller = _targetController;
    final selection = controller.selection;
    final text = controller.text;
    final offset = selection.isValid ? selection.start : text.length;
    controller.value = TextEditingValue(
      text: text.replaceRange(offset, selection.isValid ? selection.end : offset, placeholder),
      selection: TextSelection.collapsed(offset: offset + placeholder.length),
    );
    AppHaptics.tap();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const placeholders = [
      '{invoice_number}',
      '{client_name}',
      '{amount}',
      '{due_date}',
      '{issue_date}',
      '{business_name}',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emailTemplateTitle),
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
                controller: _subjectController,
                focusNode: _subjectFocus,
                label: l10n.emailTemplateSubjectLabel,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                    ? l10n.emailTemplateSubjectRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledTextField(
                controller: _bodyController,
                focusNode: _bodyFocus,
                label: l10n.emailTemplateBodyLabel,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                    ? l10n.emailTemplateBodyRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              FormSectionTitle(title: l10n.emailTemplatePlaceholdersTitle),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.emailTemplatePlaceholdersHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final placeholder in placeholders)
                            ActionChip(
                              label: Text(
                                placeholder,
                                style: const TextStyle(fontSize: 13),
                              ),
                              onPressed: () => _insertPlaceholder(placeholder),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: _saving ? null : _resetToDefault,
                  child: Text(l10n.emailTemplateReset),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
