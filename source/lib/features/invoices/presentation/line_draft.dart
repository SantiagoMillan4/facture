import 'package:flutter/widgets.dart';

import '../../../shared/utils/currency_formatter.dart';
import '../domain/invoice.dart';

/// Editable draft of one invoice line in the invoice form.
///
/// Owns its [TextEditingController]s (the form disposes them). A blank row
/// is dropped on save; [isValid] tells whether a filled row can be saved.
class LineDraft {
  LineDraft({
    String? id,
    String description = '',
    String quantity = '',
    String unitPrice = '',
  }) : id = id ?? 'l${DateTime.now().microsecondsSinceEpoch}_${_seq++}',
       descriptionController = TextEditingController(text: description),
       quantityController = TextEditingController(text: quantity),
       unitPriceController = TextEditingController(text: unitPrice);

  static int _seq = 0;

  final String id;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;

  bool get isBlank =>
      descriptionController.text.trim().isEmpty &&
      quantityController.text.trim().isEmpty &&
      unitPriceController.text.trim().isEmpty;

  /// Null when the row is blank (dropped on save).
  InvoiceLineItem? toLineItem() {
    if (isBlank) return null;
    return InvoiceLineItem(
      id: id,
      description: descriptionController.text.trim(),
      quantity: parseQuantity(quantityController.text),
      unitPrice: parseAmountToCents(unitPriceController.text) / 100.0,
    );
  }

  /// A filled row is valid with a description and positive quantity
  /// and unit price.
  bool get isValid {
    final item = toLineItem();
    return item != null &&
        item.description.isNotEmpty &&
        item.quantity > 0 &&
        item.unitPrice > 0;
  }

  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
  }
}
