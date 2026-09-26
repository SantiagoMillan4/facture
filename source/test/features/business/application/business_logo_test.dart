import 'dart:io';

import 'package:facture/features/business/application/business_logo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('business_logo_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          pathProviderChannel,
          (call) async => tempDir.path,
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imagePickerChannel, null);
    tempDir.deleteSync(recursive: true);
  });

  Uint8List bytes(List<int> b) => Uint8List.fromList(b);

  List<String> logoFiles() =>
      tempDir
          .listSync()
          .whereType<File>()
          .map((f) => f.path.split('/').last)
          .where((n) => n.startsWith('business-logo.'))
          .toList()
        ..sort();

  /// Fakes a gallery pick: the platform returns the picked file's path.
  void mockGalleryPick(String sourcePath) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(imagePickerChannel, (call) async {
          if (call.method == 'pickImage') return sourcePath;
          return null;
        });
  }

  test('generated -> generated overwrites the same file', () async {
    final first = await BusinessLogo.storeBytes(bytes([1, 2, 3]));
    final second = await BusinessLogo.storeBytes(bytes([4, 5, 6]));

    expect(second, first);
    expect(await File(second).readAsBytes(), bytes([4, 5, 6]));
    expect(logoFiles(), [first.split('/').last]);
  });

  test('imported -> generated deletes the stale import', () async {
    // Simulate a previous gallery import the way pickAndStore writes it.
    final imported = File('${tempDir.path}/business-logo.jpg');
    await imported.writeAsBytes(bytes([7, 8]));

    final generated = await BusinessLogo.storeBytes(bytes([9]));

    expect(generated.endsWith('business-logo.png'), isTrue);
    expect(await imported.exists(), isFalse);
    expect(await File(generated).readAsBytes(), bytes([9]));
    expect(logoFiles(), ['business-logo.png']);
  });

  test('generated -> imported deletes the stale generated file', () async {
    final generated = await BusinessLogo.storeBytes(bytes([9]));

    final source = File('${tempDir.path}/gallery-source.jpg');
    await source.writeAsBytes(bytes([7, 8]));
    mockGalleryPick(source.path);

    final imported = await BusinessLogo.pickAndStore();

    expect(imported, endsWith('business-logo.jpg'));
    expect(await File(generated).exists(), isFalse);
    expect(await File(imported!).readAsBytes(), bytes([7, 8]));
    expect(logoFiles(), ['business-logo.jpg']);
    // The gallery source itself is never treated as a stale sibling.
    expect(await source.exists(), isTrue);
  });

  test('repeat imports with the same extension overwrite in place', () async {
    final firstSource = File('${tempDir.path}/gallery-one.jpg');
    await firstSource.writeAsBytes(bytes([1]));
    mockGalleryPick(firstSource.path);
    final first = await BusinessLogo.pickAndStore();

    final secondSource = File('${tempDir.path}/gallery-two.jpg');
    await secondSource.writeAsBytes(bytes([2, 3]));
    mockGalleryPick(secondSource.path);
    final second = await BusinessLogo.pickAndStore();

    expect(second, first);
    expect(await File(second!).readAsBytes(), bytes([2, 3]));
    expect(logoFiles(), [first!.split('/').last]);
  });

  test('readBytes returns null for a missing file', () async {
    expect(
      await BusinessLogo.readBytes('${tempDir.path}/business-logo.png'),
      isNull,
    );
    expect(await BusinessLogo.readBytes(null), isNull);
  });

  test('delete tolerates missing files', () async {
    await BusinessLogo.delete('${tempDir.path}/business-logo.png');
    await BusinessLogo.delete(null);
  });
}
