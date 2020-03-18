import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EarpieceAudio {
  static const MethodChannel _channel =
      const MethodChannel('earpiece_audio');

  Map<String, File> loadedFiles = {};

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> setSpeakerEarpiece(bool mode) async {
    Map<String, dynamic> payload = {
      'mode': mode
    };

    return await _channel.invokeMethod("setSpeakerEarpiece", payload);
  }

  Future<File> load(String filename) async {
    if (!loadedFiles.containsKey(filename)) {
      loadedFiles[filename] = await fetchToMemory(filename);
    }
    return loadedFiles[filename];
  }

  Future<ByteData> _fetchAsset(String fileName) async {
    return await rootBundle.load('assets/$fileName');
  }

  Future<File> fetchToMemory(String filename) async {
    final file = File('${(await getTemporaryDirectory()).path}/$filename');

    await file.create(recursive: true);
    return await file
        .writeAsBytes((await _fetchAsset(filename)).buffer.asUint8List());
  }

  Future<String> play(String filename, {bool isLocal}) async {
    File file = await load(filename);

    isLocal ??= file.path.startsWith("/") ||
        file.path.startsWith("file://") ||
        file.path.substring(1).startsWith(':\\');

    Map<String, dynamic> body = {
      'url': file.path
    };
    return await _channel.invokeMethod('play', body);
  }
}
