import 'dart:ui' as ui;

import 'package:facture/features/logo/application/logo_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// PNG magic bytes: every renderLogo output must start with these.
const _pngMagic = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

void main() {
  group('monogramFor', () {
    test('takes the first letters of the first two words', () {
      expect(monogramFor('Atelier Lumen'), 'AL');
    });

    test('single word gives a single initial', () {
      expect(monogramFor('Plomberie'), 'P');
    });

    test('ignores extra words and whitespace', () {
      expect(monogramFor('  atelier   lumen  design '), 'AL');
    });

    test('uppercases lowercase input', () {
      expect(monogramFor('atelier lumen'), 'AL');
    });

    test('empty or blank names give an empty monogram', () {
      expect(monogramFor(''), '');
      expect(monogramFor('   '), '');
    });
  });

  group('renderLogo', () {
    const color = ui.Color(0xFF0F766E);

    test('produces a valid PNG for every style', () async {
      for (final style in LogoStyle.values) {
        final bytes = await renderLogo(
          name: 'Atelier Lumen',
          style: style,
          color: color,
        );
        expect(bytes.length, greaterThan(_pngMagic.length));
        expect(bytes.sublist(0, 8), _pngMagic);
      }
    });

    test('different styles render different images', () async {
      final circle = await renderLogo(
        name: 'Atelier Lumen',
        style: LogoStyle.monogramCircle,
        color: color,
      );
      final square = await renderLogo(
        name: 'Atelier Lumen',
        style: LogoStyle.monogramRoundedSquare,
        color: color,
      );
      final wordmark = await renderLogo(
        name: 'Atelier Lumen',
        style: LogoStyle.wordmark,
        color: color,
      );
      expect(circle, isNot(square));
      expect(circle, isNot(wordmark));
      expect(square, isNot(wordmark));
    });

    test('renders without a name (empty monogram / blank wordmark)', () async {
      for (final style in LogoStyle.values) {
        final bytes = await renderLogo(name: '', style: style, color: color);
        expect(bytes.sublist(0, 8), _pngMagic);
      }
    });

    test('long names shrink instead of failing', () async {
      final bytes = await renderLogo(
        name: 'Atelier de design Lumen extraordinaire et compagnie',
        style: LogoStyle.wordmark,
        color: color,
      );
      expect(bytes.sublist(0, 8), _pngMagic);
    });
  });
}
