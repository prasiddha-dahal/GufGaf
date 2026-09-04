import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

class AudioService {
  static final AudioRecorder _recorder = AudioRecorder();
    static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  static Future<void> startRecording(String path) async {
    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      return;
    }

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
      path: path,
    );
  }

  static Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  static Future<void> cancelRecording() async {
    await _recorder.cancel();
  }

   static Future<String?> uploadAudio(String filePath) async {
    try {
      final file = File(filePath);

      final fileName =
          'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      final ref = _storage
          .ref()
          .child('voice_messages')
          .child(fileName);

      await ref.putFile(file);

      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if(kDebugMode){
      print('Audio upload error: $e');
      }
      return null;
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}
