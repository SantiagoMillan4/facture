import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
        .setMockMethodCallHandler(
      const MethodChannel('net.nfet.printing'),
      (call) async {
        if (call.method == 'printingInfo') {
          return <String, dynamic>{'canRaster': false};
        }
        return null;
      },
    );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('net.nfet.printing'), null);
  });
}
