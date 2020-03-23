import 'dart:developer';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:earpiece_audio/earpiece_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  AudioCache _audioCache = AudioCache();
  EarpieceAudio _earpiece = EarpieceAudio();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: () async {
                  final responsePath = await _earpiece.stop();
                  print(responsePath);
                },
                child: Text("Matin audio"),
              ),
              RaisedButton(
                onPressed: () async {
                  final responsePath = await _earpiece.play("audios/phone_calling.mp4");
                  print(responsePath);
                },
                child: Text("Nyalain audio"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
//    final respone = await EarpieceAudio.setSpeakerEarpiece(false);
//
//    print(respone);

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await EarpieceAudio.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

//    _audioCache.loop("audios/phone_calling.mp4");
//    _audioCache.respectSilence = false;
    final responsePath = await _earpiece.play("audios/phone_calling.mp4");
    print(responsePath);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
}
