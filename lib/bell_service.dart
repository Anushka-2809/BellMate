import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BellService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playBellSound() async {
    try {
      final assetPath = kIsWeb
          ? 'sounds/school-bell-199584.wav'
          : 'sounds/school-bell-199584.mp3';
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print("Error playing bell sound: $e");
    }
  }
}
