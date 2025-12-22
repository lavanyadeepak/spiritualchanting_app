import 'package:flutter/material.dart';
import 'package:spiritual_chanting/models/chant.dart';
import 'package:spiritual_chanting/models/playlist_item.dart';
import 'package:spiritual_chanting/services/chant_service.dart';
import 'package:spiritual_chanting/pages/player_page.dart';

class ChantingHomePage extends StatefulWidget {
  const ChantingHomePage({super.key});

  @override
  State<ChantingHomePage> createState() => _ChantingHomePageState();
}

class _ChantingHomePageState extends State<ChantingHomePage> {
  List<Chant> chants = [];
  List<PlaylistItem> playlist = [];
  Chant? selectedChant;
  int chantCount = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChants();
  }

  Future<void> _loadChants() async {
    try {
      chants = await ChantService().loadChants();
      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading chants: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiritual Chanting',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF5E42A6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chant:', style: TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<Chant>(
                value: selectedChant,
                hint: const Text('--Select a Chant--'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF5E42A6).withOpacity(0.3),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                dropdownColor: const Color(0xFF5E42A6),
                style: const TextStyle(color: Colors.white),
                items: chants.map((chant) {
                  return DropdownMenuItem<Chant>(
                    value: chant,
                    child: Text(chant.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedChant = value);
                  }
                },
              ),

            const SizedBox(height: 20),
            const Text('Repeat Count:', style: TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF5E42A6).withOpacity(0.3),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: '1',
                hintStyle: const TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                final parsed = int.tryParse(value) ?? 1;
                if (parsed > 0) setState(() => chantCount = parsed);
              },
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: selectedChant == null ? null : () {
                    setState(() {
                      playlist.add(PlaylistItem(chant: selectedChant!, repeatCount: chantCount));
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add to Playlist'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => playlist.clear()),
                  icon: const Icon(Icons.clear),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: playlist.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerPage(playlist: playlist),
                        ),
                      );
                    },
              icon: const Icon(Icons.play_arrow, size: 32),
              label: const Text('PLAY', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),

            const SizedBox(height: 30),
            const Text('Current Playlist:', style: TextStyle(fontSize: 20, color: Colors.amber)),
            const SizedBox(height: 10),
            playlist.isEmpty
                ? const Center(child: Text('No chants added yet', style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      final item = playlist[index];
                      return Card(
                        color: const Color(0xFF5E42A6).withOpacity(0.5),
                        child: ListTile(
                          title: Text(item.chant.name, style: const TextStyle(color: Colors.white)),
                          trailing: Text('×${item.repeatCount}',
                              style: const TextStyle(color: Colors.amber, fontSize: 18)),
                          onTap: () => setState(() => playlist.removeAt(index)),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}