class Bible {
  final String id;
  final String name;
  final String abbreviation;

  Bible({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nome não disponível',
      abbreviation: json['abbreviation'] ?? '',
    );
  }
}
