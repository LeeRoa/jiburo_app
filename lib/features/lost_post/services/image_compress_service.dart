import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressService {
  static Future<File?> compressForDetail(String originalPath) async {
    return _compress(
      originalPath,
      suffix: '_detail',
      minWidth: 1080,
      quality: 80,
    );
  }

  static Future<File?> compressForThumbnail(String originalPath) async {
    return _compress(
      originalPath,
      suffix: '_thumb',
      minWidth: 200,
      quality: 75,
    );
  }

  static Future<File?> _compress(
    String originalPath, {
    required String suffix,
    required int minWidth,
    required int quality,
  }) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}$suffix.webp';

    final result = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      targetPath,
      minWidth: minWidth,
      minHeight: minWidth,
      quality: quality,
      format: CompressFormat.webp,
    );

    return result != null ? File(result.path) : null;
  }
}
