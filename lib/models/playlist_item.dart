import 'package:spiritual_chanting/models/chant.dart';

class PlaylistItem {
  final Chant chant;
  final int repeatCount;

  PlaylistItem({required this.chant, required this.repeatCount});
}