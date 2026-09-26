import 'dart:typed_data';
import 'dart:ui' as ui;

// package:flutter/painting.dart is imported for text layout only (no
// widgets): the PNG renderer needs TextPainter to measure and draw the
// business name. All canvas work stays on dart:ui.
import 'package:flutter/painting.dart';

/// The visual styles the in-app logo creator offers.
enum LogoStyle {
  /// White initials on a filled accent circle.
  monogramCircle,

  /// White initials on a filled accent rounded square.
  monogramRoundedSquare,

  /// The business name in accent color on a transparent background.
  wordmark,
}

/// The initials shown for the monogram styles: the first character of each
/// of the first two words, uppercased ("Atelier Lumen" → "AL").
String monogramFor(String name) {
  final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return '';
  final initials = words
      .take(2)
      .map((w) => String.fromCharCode(w.runes.first).toUpperCase());
  return initials.join();
}

/// Renders a simple business logo to PNG bytes at [size]×[size].
///
/// Monogram styles draw white initials on an accent shape; the wordmark
/// draws the business name in the accent color on transparency. The text
/// is always scaled to fit, so long names shrink instead of clipping.
Future<Uint8List> renderLogo({
  required String name,
  required LogoStyle style,
  required ui.Color color,
  int size = 1024,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final side = size.toDouble();

  if (style == LogoStyle.wordmark) {
    _drawWordmark(canvas, name.trim(), color, side);
  } else {
    _drawMonogram(canvas, monogramFor(name), style, color, side);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  picture.dispose();
  image.dispose();
  return bytes!.buffer.asUint8List();
}

void _drawMonogram(
  ui.Canvas canvas,
  String monogram,
  LogoStyle style,
  ui.Color color,
  double side,
) {
  final paint = ui.Paint()..color = color;
  final center = ui.Offset(side / 2, side / 2);
  final radius = side * 0.36;
  if (style == LogoStyle.monogramCircle) {
    canvas.drawCircle(center, radius, paint);
  } else {
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromCircle(center: center, radius: radius),
        ui.Radius.circular(side * 0.22),
      ),
      paint,
    );
  }
  if (monogram.isEmpty) return;
  // Fit the initials inside ~60% of the shape's diameter.
  final maxWidth = radius * 1.2;
  final painter = _fittedTextPainter(
    monogram,
    const ui.Color(0xFFFFFFFF),
    FontWeight.w700,
    maxWidth,
    side * 0.5,
  );
  _drawCentered(canvas, painter, center);
}

/// Draws [text] centered, shrinking the font until it fits [maxWidth].
void _drawWordmark(ui.Canvas canvas, String text, ui.Color color, double side) {
  if (text.isEmpty) return;
  final painter = _fittedTextPainter(
    text,
    color,
    FontWeight.w700,
    side * 0.86,
    side * 0.22,
  );
  _drawCentered(canvas, painter, ui.Offset(side / 2, side / 2));
}

/// A [TextPainter] for [text] laid out at the largest size that fits
/// [maxWidth], starting from [startSize] and shrinking.
TextPainter _fittedTextPainter(
  String text,
  ui.Color color,
  FontWeight weight,
  double maxWidth,
  double startSize,
) {
  var size = startSize;
  late TextPainter painter;
  while (true) {
    painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: size * 0.02,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    if (painter.width <= maxWidth || size <= 8) break;
    size *= 0.9;
  }
  return painter;
}

void _drawCentered(ui.Canvas canvas, TextPainter painter, ui.Offset center) {
  painter.paint(
    canvas,
    ui.Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
  );
}
