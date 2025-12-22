import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:spiritual_chanting/models/playlist_item.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Handle interruptions (e.g., phone calls)
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace st) {
      print('Audio error: $e');
    });
  }

  Future<void> playPlaylist(List<PlaylistItem> playlist) async {
    if (playlist.isEmpty) return;

    final concatenatingSource = ConcatenatingAudioSource(
      children: playlist.expand((item) {
        return List.generate(item.repeatCount, (_) => AudioSource.uri(Uri.parse(item.chant.url)));
      }).toList(),
      useLazyPreparation: true,
    );

    await _player.setAudioSource(concatenatingSource, preload: false);
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  Future<void> pause() async => _player.pause();
  Future<void> resume() async => _player.play();

  void dispose() {
    _player.dispose();
  }
}