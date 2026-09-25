import 'package:flutter/widgets.dart';

import '../../l10n/app_l10n.dart';

/// Validates an optional listing URL field: empty is fine, otherwise the
/// value must be an absolute http/https URL.
String? validateListingUrl(String? value, BuildContext context) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return null;
  final uri = Uri.tryParse(trimmed);
  final valid =
      uri != null &&
      uri.isAbsolute &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
  if (!valid) return context.l10n.validationInvalidUrl;
  return null;
}
