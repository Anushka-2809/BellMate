import 'package:audioplayers/audioplayers.dart';

class BellService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playBellSound() async {
    try {
      // On Flutter web, AssetSource should be relative to the assets root (omit 'assets/')
      const String assetPath = 'sounds/school-bell-199584.mp3';
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // ignore: avoid_print
      print('Error playing bell sound: $e');
    }
  }
}
