import 'package:facture/features/clients/presentation/client_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClientAvatar.initialsOf', () {
    test('takes the first letters of the first and last words', () {
      expect(ClientAvatar.initialsOf('Acme Inc'), 'AI');
      expect(ClientAvatar.initialsOf('alice tremblay'), 'AT');
    });

    test('single word gives one initial', () {
      expect(ClientAvatar.initialsOf('Solo'), 'S');
    });

    test('ignores extra whitespace', () {
      expect(ClientAvatar.initialsOf('  Acme   Inc  '), 'AI');
    });

    test('empty name gives a placeholder', () {
      expect(ClientAvatar.initialsOf(''), '?');
      expect(ClientAvatar.initialsOf('   '), '?');
    });
  });
}
