import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_l10n.dart';

import '../theme/app_spacing.dart';

/// A labeled text field with consistent spacing and error styling.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixText,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.helperText,
    this.helperMaxLines,
    this.clampPercent = false,
  });

  /// Floating label shown above the field. Null renders no label — used when
  /// a group header or the unit suffix already describes the field.
  final String? label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int maxLines;

  /// Explicit focus control. When set, prefer driving focus through this
  /// node instead of [autofocus] so the focused field can change as the
  /// form changes.
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  /// Unit suffix shown inside the field, e.g. "%" or "$".
  final String? suffixText;
  final AutovalidateMode autovalidateMode;

  /// When false the field is greyed out and non-editable.
  final bool enabled;

  /// Short explanatory text rendered under the field.
  final String? helperText;

  /// Max lines for the helper text. Null keeps Flutter's default (single
  /// line, truncated); set to 2+ when the helper is a real sentence that
  /// should wrap instead of being cut off.
  final int? helperMaxLines;

  /// When true, a [TextInputFormatter] clamps the parsed value to the 0–100
  /// range live as the user types or pastes — it is impossible to enter a
  /// percent above 100 (or below 0). Save-time validators stay in place as
  /// a safety net; this is the primary behavior.
  final bool clampPercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffixText,
          helperText: helperText,
          helperMaxLines: helperMaxLines,
        ),
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        autovalidateMode: autovalidateMode,
        inputFormatters: clampPercent ? const [_PercentClampFormatter()] : null,
        onChanged: onChanged,
        autofocus: autofocus,
        focusNode: focusNode,
        maxLines: maxLines,
      ),
    );
  }
}

/// A [TextInputFormatter] that makes it impossible to enter a percent
/// outside the 0–100 range: the parsed value is clamped as the user types or
/// pastes, and the cursor is placed at the end of the clamped text so typing
/// stays sane. Empty and partial input (e.g. "10.") passes through
/// untouched; valid in-range values are never modified.
class _PercentClampFormatter extends TextInputFormatter {
  const _PercentClampFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final parsed = double.tryParse(newValue.text.trim());
    if (parsed == null) return newValue;
    final clamped = parsed > 100 ? '100' : (parsed < 0 ? '0' : null);
    if (clamped == null) return newValue;
    return TextEditingValue(
      text: clamped,
      selection: TextSelection.collapsed(offset: clamped.length),
      composing: TextRange.empty,
    );
  }
}

/// A labeled numeric field that validates its value parses to [double].
class LabeledAmountField extends StatelessWidget {
  const LabeledAmountField({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.onChanged,
    this.allowDecimals = true,
    this.autofocus = false,
    this.suffixText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.enabled = true,
    this.clampPercent = false,
  });

  /// Floating label shown above the field. Null renders no label — used when
  /// a group header or the unit suffix already describes the field.
  final String? label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool allowDecimals;
  final bool autofocus;

  /// Unit suffix shown inside the field, e.g. "%" or "$".
  final String? suffixText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode autovalidateMode;

  /// When false the field is greyed out and non-editable.
  final bool enabled;

  /// When true, a [TextInputFormatter] clamps the parsed value to the 0–100
  /// range live as the user types or pastes. See [LabeledTextField.clampPercent].
  final bool clampPercent;

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: label,
      controller: controller,
      hint: hint,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimals),
      textCapitalization: TextCapitalization.none,
      autofocus: autofocus,
      suffixText: suffixText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      clampPercent: clampPercent,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.validationEnterAnAmount;
            }
            final parsed = double.tryParse(value.trim());
            if (parsed == null || parsed < 0) {
              return context.l10n.validationEnterNonNegative;
            }
            return null;
          },
      onChanged: onChanged,
    );
  }
}
