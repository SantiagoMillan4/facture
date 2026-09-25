import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';

/// Settings — scaffold placeholder.
///
/// TODO: business profile (name, address, TPS/TVQ registration numbers,
/// registration status for the small-supplier rule), language, about,
/// feedback, Law 25 privacy policy link.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: const Center(
        child: Text('TODO: business profile, taxes, about'),
      ),
    );
  }
}
