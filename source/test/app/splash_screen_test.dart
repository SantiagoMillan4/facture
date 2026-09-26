import 'package:facture/app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Regression: the logo once rendered stuck in the top-left corner, then
  // (after a partial fix) centered inside a shrink-wrapped background band.
  // The splash is a direct child of an AnimatedSwitcher whose Stack lays
  // children out with loose constraints, so the background must actively
  // expand to fill the screen.
  testWidgets('splash background fills the screen and logo is centered', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: SplashScreen(onReady: () {})));
    await tester.pump(const Duration(milliseconds: 700));

    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    // Background fills the whole screen (no band).
    final bg = find.descendant(
      of: find.byType(SplashScreen),
      matching: find.byType(ColoredBox),
    );
    expect(bg, findsOneWidget);
    expect(tester.getSize(bg), screen);
    // Logo is centered (not stuck in a corner).
    final imageCenter = tester.getCenter(find.byType(Image));
    expect(imageCenter.dx, moreOrLessEquals(screen.width / 2, epsilon: 1));
    expect(imageCenter.dy, moreOrLessEquals(screen.height / 2, epsilon: 1));
  });
}
