import 'package:audioplayers/audioplayers.dart';

class BellService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playBellSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/bell.mp3'));
    } catch (e) {
      print("Error playing bell sound: $e");
    }
  }
}
