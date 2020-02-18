import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:earpiece_audio/earpiece_audio.dart';

void main() {
  const MethodChannel channel = MethodChannel('earpiece_audio');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await EarpieceAudio.platformVersion, '42');
  });
}
