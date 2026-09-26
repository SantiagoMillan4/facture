import 'package:facture/app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Regression: the logo once rendered stuck in the top-left corner because
  // Scaffold layers its body in an internal Stack with loose constraints,
  // so the centering Stack shrink-wrapped instead of filling the screen.
  testWidgets('splash logo is centered on screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SplashScreen(onReady: () {})),
    );
    await tester.pump(const Duration(milliseconds: 700));

    final imageCenter = tester.getCenter(find.byType(Image));
    final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(imageCenter.dx, moreOrLessEquals(screen.width / 2, epsilon: 1));
    expect(imageCenter.dy, moreOrLessEquals(screen.height / 2, epsilon: 1));
  });
}
