import 'package:flutter/material.dart';

/// The primary "add" action of a page: a large, full-width outlined pill
/// button with an icon and a bold label in the accent color. Matches the
/// Rentable "Add property" style: stadium shape, thin outline, content
/// below the list pinned above the tab bar. Used for "New invoice" on the
/// Invoices page, "Add client" on the Clients page, and "Add item" on the
/// catalog page so all three share one template.
class BigAddButton extends StatelessWidget {
  const BigAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: accent),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
