import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../theme/app_spacing.dart';

/// Short locale-aware date: dd/mm/yyyy in French (Québec), mm/dd/yyyy in
/// English. Shared by date fields and invoice list rows.
String formatShortDate(BuildContext context, DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year.toString();
  return context.isFrench ? '$d/$m/$y' : '$m/$d/$y';
}

/// A labeled date field: shows the date formatted for the locale, opens a
/// native date picker on tap — [CupertinoDatePicker] in a bottom sheet on
/// iOS/macOS, the Material date picker elsewhere.
class AdaptiveDateField extends StatelessWidget {
  const AdaptiveDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  String _format(BuildContext context, DateTime date) =>
      formatShortDate(context, date);

  Future<void> _pick(BuildContext context) async {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      await _pickCupertino(context);
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) onChanged(picked);
    }
  }

  Future<void> _pickCupertino(BuildContext context) async {
    final l10n = context.l10n;
    var temp = value;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(l10n.dialogCancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: Text(l10n.done),
                  onPressed: () {
                    onChanged(temp);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: value,
                minimumDate: DateTime(2000),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (date) => temp = date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          InkWell(
            onTap: () => _pick(context),
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              child: Text(
                _format(context, value),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
