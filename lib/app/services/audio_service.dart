import 'package:record/record.dart';

class AudioService {
  static final AudioRecorder _recorder = AudioRecorder();

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

  void dispose() {
    _recorder.dispose();
  }
}
