import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String bibleId;
  final String abbreviation;
  final String name;
  final String nameLong;

  const Book({
    required this.id,
    required this.bibleId,
    required this.abbreviation,
    required this.name,
    required this.nameLong,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      bibleId: json['bibleId'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      name: json['name'] ?? '',
      nameLong: json['nameLong'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, bibleId, abbreviation, name, nameLong];
}
