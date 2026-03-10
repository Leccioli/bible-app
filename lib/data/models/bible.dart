import 'package:equatable/equatable.dart';

class Bible extends Equatable {
  final String id;
  final String name;
  final String abbreviation;

  const Bible({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Name not available',
      abbreviation: json['abbreviation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, abbreviation];
}
