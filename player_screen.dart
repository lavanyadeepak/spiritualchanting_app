import 'package:flutter/material.dart';
import 'chant_settings_card.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // State for Chant Settings
  int _repeatCount = 1;
  bool _stopAfterCompletion = true;

  // Player State (Mock)
  bool _isPlaying = false;
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiritual Chanting Player'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Placeholder for Album Art
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.music_note, size: 100, color: Colors.grey),
                ),
              ),
            ),
            
            // Track Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Track Title",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Chant Settings Card Integration
            ChantSettingsCard(
              repeatCount: _repeatCount,
              stopAfterCompletion: _stopAfterCompletion,
              onRepeatCountChanged: (value) {
                setState(() {
                  _repeatCount = value;
                });
              },
              onStopAfterCompletionChanged: (value) {
                setState(() {
                  _stopAfterCompletion = value;
                });
              },
            ),

            // Progress Bar (Mock)
            Slider(
              value: _currentSliderValue,
              max: 100,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),

            // Playback Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 40),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 40),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}