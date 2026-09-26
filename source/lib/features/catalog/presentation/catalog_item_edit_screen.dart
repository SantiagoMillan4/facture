import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../application/catalog_providers.dart';
import '../domain/catalog_item.dart';

/// Add / edit a catalog item. [item] is null for a new item.
///
/// Description is required; the price must be above zero.
class CatalogItemEditScreen extends ConsumerStatefulWidget {
  const CatalogItemEditScreen({super.key, this.item});

  final CatalogItem? item;

  @override
  ConsumerState<CatalogItemEditScreen> createState() =>
      _CatalogItemEditScreenState();
}

class _CatalogItemEditScreenState
    extends ConsumerState<CatalogItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _priceController = TextEditingController(
      text: item == null ? '' : (item.unitPriceCents / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final item = CatalogItem(
      id: widget.item?.id ?? CatalogItem.newId(),
      description: _descriptionController.text.trim(),
      unitPriceCents: parseAmountToCents(_priceController.text),
    );
    AppHaptics.confirm();
    await ref.read(catalogItemsProvider.notifier).saveItem(item);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null ? l10n.catalogNewTitle : l10n.catalogEditTitle,
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
                controller: _descriptionController,
                label: l10n.catalogDescriptionLabel,
                hint: l10n.catalogDescriptionHint,
                autofocus: widget.item == null,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? l10n.catalogDescriptionRequired
                        : null,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledAmountField(
                controller: _priceController,
                label: l10n.catalogPriceLabel,
                suffixText: '\$',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                validator: (value) =>
                    parseAmountToCents(value ?? '') <= 0
                        ? l10n.catalogPriceRequired
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
