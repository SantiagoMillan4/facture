import 'package:facture/shared/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseAmountToCents', () {
    test('parses dot and comma decimals', () {
      expect(parseAmountToCents('115.47'), 11547);
      expect(parseAmountToCents('115,47'), 11547);
    });

    test('ignores spaces, non-breaking spaces and dollar signs', () {
      expect(parseAmountToCents('1 234,56 \$'), 123456);
      expect(parseAmountToCents('1 234,56 \$'), 123456);
      // Narrow no-break space (U+202F) used by the French formatter.
      expect(parseAmountToCents('115,47 \$'), 11547);
    });

    test('unparseable input is zero', () {
      expect(parseAmountToCents(''), 0);
      expect(parseAmountToCents('abc'), 0);
    });
  });

  group('parseQuantity', () {
    test('parses decimals with dot or comma', () {
      expect(parseQuantity('2.5'), 2.5);
      expect(parseQuantity('2,5'), 2.5);
    });

    test('unparseable input is zero', () {
      expect(parseQuantity(''), 0);
      expect(parseQuantity('xyz'), 0);
    });
  });
}
