import 'dart:async';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EarpieceAudio {
  static const MethodChannel _channel =
      const MethodChannel('earpiece_audio');

  Map<String, File> loadedFiles = {};
  static AudioCache _audioCache = AudioCache();
  static AudioPlayer _audioPlayer;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> _setSpeakerEarpiece(bool mode) async {
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
    if (Platform.isAndroid) {
      return await _playAndroidDevice(filename);
    } else if (Platform.isIOS) {
      return await _playIosDevice(filename);
    }

    return 'device_unknown';
  }

  Future<String> stop() async {
    if (Platform.isAndroid) {
      return await _stopAndroidDevice();
    } else if (Platform.isIOS) {
      return await _stopIosDevice();
    }

    return "stop";
  }

  Future<String> _playIosDevice(String filename) async {
    Map<String, dynamic> body = {
      'filename': filename
    };

    return await _channel.invokeMethod('play', body);
  }

  Future<String> _playAndroidDevice(String filename) async {
    await _setSpeakerEarpiece(false);

    _audioPlayer = await _audioCache.loop(filename);

    return 'success';
  }

  Future<String> _stopIosDevice() async {
    return await _channel.invokeMethod("stop");
  }

  Future<String> _stopAndroidDevice() async {
    _audioPlayer?.stop();

    await _setSpeakerEarpiece(true);

    return 'audio stop';
  }
}
