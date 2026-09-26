import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/big_add_button.dart';
import '../../business/application/business_logo.dart';
import '../../business/application/business_profile_providers.dart';
import '../../business/domain/business_profile.dart';
import '../application/logo_generator.dart';
import 'logo_options.dart';
import 'logo_preview.dart';

/// In-app logo creator: generates a simple logo from the business name.
///
/// The user picks a style (accent monogram or wordmark) and a color, sees
/// a live preview, and saving stores the PNG as the business logo —
/// creating a minimal profile when there isn't one yet. A brand-new
/// profile is always small-supplier so the creator can never silently
/// switch taxes on.
class LogoCreatorScreen extends ConsumerStatefulWidget {
  const LogoCreatorScreen({super.key, this.initialName = ''});

  final String initialName;

  @override
  ConsumerState<LogoCreatorScreen> createState() => _LogoCreatorScreenState();
}

class _LogoCreatorScreenState extends ConsumerState<LogoCreatorScreen> {
  /// Fixed, mode-independent palette: these colors are baked into the
  /// generated PNG, not UI theming.
  static const _palette = [
    Color(0xFF0F766E),
    Color(0xFF1D4ED8),
    Color(0xFF7C3AED),
    Color(0xFFDC2626),
    Color(0xFFD97706),
    Color(0xFF334155),
  ];

  late final TextEditingController _nameController;
  var _style = LogoStyle.monogramCircle;
  var _colorIndex = 0;
  Uint8List? _previewBytes;
  var _rendering = false;
  var _saving = false;
  var _renderToken = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _renderPreview();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty && !_saving;

  Future<void> _renderPreview() async {
    final token = ++_renderToken;
    final name = _nameController.text;
    if (name.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _previewBytes = null;
          _rendering = false;
        });
      }
      return;
    }
    setState(() => _rendering = true);
    final bytes = await renderLogo(
      name: name,
      style: _style,
      color: _palette[_colorIndex],
    );
    if (!mounted || token != _renderToken) return;
    setState(() {
      _previewBytes = bytes;
      _rendering = false;
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    try {
      final name = _nameController.text.trim();
      final bytes = await renderLogo(
        name: name,
        style: _style,
        color: _palette[_colorIndex],
      );
      final path = await BusinessLogo.storeBytes(bytes);
      final notifier = ref.read(businessProfileProvider.notifier);
      final profile = ref.read(businessProfileProvider).value;
      final oldPath = profile?.logoPath;
      if (oldPath != null && oldPath != path) {
        await BusinessLogo.delete(oldPath);
      }
      if (profile != null) {
        await notifier.saveProfile(profile.copyWith(logoPath: path));
      } else {
        await notifier.saveProfile(
          BusinessProfile(
            name: name,
            taxStatus: TaxRegistrationStatus.smallSupplier,
            logoPath: path,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(path);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.logoCreatorTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  l10n.logoCreatorSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                LogoPreview(bytes: _previewBytes, rendering: _rendering),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.logoCreatorNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => _renderPreview(),
                ),
                const SizedBox(height: AppSpacing.lg),
                LogoOptions(
                  style: _style,
                  colorIndex: _colorIndex,
                  palette: _palette,
                  onStyleChanged: (style) {
                    setState(() => _style = style);
                    _renderPreview();
                  },
                  onColorChanged: (index) {
                    setState(() => _colorIndex = index);
                    _renderPreview();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: BigAddButton(
              key: const ValueKey('useLogoButton'),
              label: l10n.logoCreatorSave,
              icon: Icons.check,
              onPressed: _canSave ? _save : null,
            ),
          ),
        ],
      ),
    );
  }
}
