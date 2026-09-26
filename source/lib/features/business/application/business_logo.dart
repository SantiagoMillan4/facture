import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// On-device business logo storage.
///
/// The picked image is copied into the app documents directory (so the
/// logo survives gallery moves and deletions); [BusinessProfile.logoPath]
/// points at that private copy.
class BusinessLogo {
  static const _fileName = 'business-logo';

  /// Lets the user pick an image and stores a private copy of it.
  /// Returns the stored path, or null when the user cancels.
  static Future<String?> pickAndStore() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    if (picked == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final dotParts = picked.path.split('.');
    final ext = dotParts.length > 1 ? dotParts.last : 'png';
    final target = File('${dir.path}/$_fileName.$ext');
    await File(picked.path).copy(target.path);
    await _deleteStaleSiblings(target.path);
    return target.path;
  }

  /// Stores generated logo bytes (from the in-app logo creator) as a
  /// private copy. Overwrites any previous generated logo. Returns the
  /// stored path.
  static Future<String> storeBytes(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final target = File('${dir.path}/$_fileName.png');
    await target.writeAsBytes(bytes, flush: true);
    await _deleteStaleSiblings(target.path);
    return target.path;
  }

  /// Reads the stored logo, or null when there is none or it's unreadable.
  static Future<Uint8List?> readBytes(String? path) async {
    if (path == null || path.isEmpty) return null;
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  /// Deletes the stored logo file, if any.
  static Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // A missing logo is not an error worth surfacing.
    }
  }

  /// Deletes stale logo files sharing the fixed basename but not [keepPath
  /// (e.g. a previous `business-logo.jpg` after storing `business-logo.png`).
  /// Generated logos always use `.png` while imports keep the picked
  /// extension, so switching sources would otherwise orphan the old file.
  /// The newly written file itself is never touched. Best-effort.
  static Future<void> _deleteStaleSiblings(String keepPath) async {
    try {
      final dir = Directory(File(keepPath).parent.path);
      await for (final entity in dir.list()) {
        if (entity is File &&
            entity.path != keepPath &&
            entity.path.split('/').last.startsWith('$_fileName.')) {
          await entity.delete();
        }
      }
    } catch (_) {
      // Cleanup is best-effort; a stale sibling is harmless.
    }
  }
}
