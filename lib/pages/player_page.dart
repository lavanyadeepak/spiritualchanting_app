import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spiritual_chanting/models/playlist_item.dart';
import 'package:spiritual_chanting/services/audio_service.dart';

class PlayerPage extends StatefulWidget {
  final List<PlaylistItem> playlist;

  const PlayerPage({super.key, required this.playlist});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioService _audioService;
  int _currentIndex = 0;
  int _currentRepeat = 1;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _audioService.init().then((_) {
      _audioService.playPlaylist(widget.playlist);
    });

    _audioService.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          _currentIndex = index;
          // Calculate which playlist item and repeat we're on
          int total = 0;
          for (var item in widget.playlist) {
            if (total + item.repeatCount > index) {
              _currentRepeat = index - total + 1;
              break;
            }
            total += item.repeatCount;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Note: We don't dispose here because AudioService is singleton
    super.dispose();
  }

  PlaylistItem get currentItem {
    int total = 0;
    for (var item in widget.playlist) {
      if (total + item.repeatCount > _currentIndex) {
        return item;
      }
      total += item.repeatCount;
    }
    return widget.playlist.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: const Color(0xFF5E42A6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            Card(
              color: const Color(0xFF5E42A6).withOpacity(0.7),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      currentItem.chant.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Repeat ${_currentRepeat} of ${currentItem.repeatCount}',
                      style: const TextStyle(fontSize: 18, color: Colors.amber),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            StreamBuilder<PositionData>(
              stream: Stream.periodic(const Duration(milliseconds: 500), (_) {
                return PositionData(
                  _audioService.player.position,
                  _audioService.player.duration ?? Duration.zero,
                );
              }),
              builder: (context, snapshot) {
                final positionData = snapshot.data ??
                    PositionData(Duration.zero, _audioService.player.duration ?? Duration.zero);
                return Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: positionData.duration.inMilliseconds.toDouble(),
                      value: positionData.position.inMilliseconds.toDouble().clamp(0.0, positionData.duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        _audioService.player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(positionData.position)),
                          Text(_formatDuration(positionData.duration)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.stop),
                  onPressed: () => _audioService.stop(),
                ),
                const SizedBox(width: 20),
                StreamBuilder<PlayerState>(
                  stream: _audioService.player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return IconButton(
                      iconSize: 72,
                      icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                      onPressed: playing ? _audioService.pause : _audioService.resume,
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}