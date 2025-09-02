import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playBellSound() async {
    try {
      // Replace with your desired sound asset
      await _audioPlayer.setAsset('assets/sounds/bell.mp3');
      _audioPlayer.play();
    } catch (e) {
      // Handle errors
      print("Error playing sound: $e");
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
