import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [action], then polls [done] — all inside the real async zone.
///
/// The logo renderer uses the engine rasterizer (Picture.toImage) plus
/// platform channels: that chain must be triggered AND awaited inside one
/// [tester.runAsync] block, with quiet real-time delays between pumps.
/// Pumping on a tight loop, or exiting runAsync mid-flight, strands the
/// futures and the test wedges or reads stale state.
Future<void> doRealAsync(
  WidgetTester tester,
  Future<void> Function() action,
  bool Function() done, [
  String what = 'the pending work',
]) async {
  await tester.runAsync(() async {
    await action();
    for (var i = 0; i < 20 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    }
  });
  expect(done(), isTrue, reason: 'Timed out waiting for $what');
}

/// Installs a mock for the printing plugin's platform channel.
///
/// The native rasterizer doesn't exist in widget tests, so a [PdfPreview]
/// would otherwise show a never-settling loading spinner (breaking
/// pumpAndSettle) and fire unhandled MissingPluginExceptions. Reporting
/// rasterization as unavailable makes it render its static error state
/// instead, which is irrelevant to what the tests assert.
void setUpPrintingMock() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('net.nfet.printing'), (
          call,
        ) async {
          if (call.method == 'printingInfo') {
            return <String, dynamic>{'canRaster': false};
          }
          return null;
        });
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('net.nfet.printing'),
          null,
        );
  });
}
