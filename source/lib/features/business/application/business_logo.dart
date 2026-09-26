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
}
