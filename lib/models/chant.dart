class Chant {
  final String name;
  final String url;

  Chant({required this.name, required this.url});

  factory Chant.fromJson(Map<String, dynamic> json) {
    return Chant(
      name: json['chantname'] as String,
      url: json['chanturl'] as String,
    );
  }

  @override
  String toString() => name;
}