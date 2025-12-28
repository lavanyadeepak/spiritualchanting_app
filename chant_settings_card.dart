import 'package:flutter/material.dart';

class ChantSettingsCard extends StatelessWidget {
  final int repeatCount;
  final bool stopAfterCompletion;
  final ValueChanged<int> onRepeatCountChanged;
  final ValueChanged<bool> onStopAfterCompletionChanged;

  const ChantSettingsCard({
    Key? key,
    required this.repeatCount,
    required this.stopAfterCompletion,
    required this.onRepeatCountChanged,
    required this.onStopAfterCompletionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chant Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Repetitions:'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: repeatCount > 1
                          ? () => onRepeatCountChanged(repeatCount - 1)
                          : null,
                    ),
                    Text(
                      '$repeatCount',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => onRepeatCountChanged(repeatCount + 1),
                    ),
                  ],
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('Stop after completion'),
              subtitle: const Text('Do not play next item automatically'),
              value: stopAfterCompletion,
              onChanged: (bool? value) {
                if (value != null) {
                  onStopAfterCompletionChanged(value);
                }
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }
}