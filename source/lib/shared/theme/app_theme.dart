import 'package:flutter/material.dart';

/// Shared corner radii/sizing so dialogs, menus and inputs stay consistent.
class AppRadii {
  static const card = 20.0;
  static const dialog = 24.0;
  static const sheet = 28.0;
  static const menu = 16.0;
  static const input = 14.0;
}

/// Brand greens used by the splash screens.
class AppBrand {
  /// Deep premium green: light-mode splash background, matching the app
  /// icon and the light theme primary.
  static const deepGreen = Color(0xFF0F766E);

  /// Near-black green tint for the dark-mode splash, harmonized with the
  /// dark theme surface.
  static const darkSplash = Color(0xFF0A1512);
}

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );
    const pageBackground = Color(0xFFF5F7FA);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: pageBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Match the page background so scrolled-under content never shows a
        // washed-out tinted bar; no surface tint is applied.
        backgroundColor: pageBackground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        // Barely-there hairline (light mode only) so white cards lift off
        // the light scaffold without looking boxed-in.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      dialogTheme: _dialogTheme,
      popupMenuTheme: _popupMenuTheme,
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF102A43),
        displayColor: const Color(0xFF102A43),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF14B8A6),
      brightness: Brightness.dark,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Match the page background so scrolled-under content never shows a
        // washed-out tinted bar; no surface tint is applied.
        backgroundColor: Color(0xFF0B1220),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      dialogTheme: _dialogTheme,
      popupMenuTheme: _popupMenuTheme,
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFE2E8F0),
        displayColor: const Color(0xFFE2E8F0),
      ),
    );
  }

  static final _dialogTheme = DialogThemeData(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.dialog),
    ),
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
  );

  static final _popupMenuTheme = PopupMenuThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.menu),
    ),
    menuPadding: const EdgeInsets.symmetric(vertical: 8),
  );

  /// App-wide modal sheet styling: rounded top corners, a drag handle on
  /// every sheet, and the M3 container color so sheets feel native without
  /// each call site repeating the same flags.
  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colorScheme) =>
      BottomSheetThemeData(
        elevation: 1,
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: width == 0
              ? BorderSide.none
              : BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: border(colorScheme.outlineVariant, width: 0),
      enabledBorder: border(colorScheme.outlineVariant, width: 0),
      focusedBorder: border(colorScheme.primary, width: 1.5),
      errorBorder: border(colorScheme.error, width: 1.2),
      focusedErrorBorder: border(colorScheme.error, width: 1.5),
    );
  }
}
