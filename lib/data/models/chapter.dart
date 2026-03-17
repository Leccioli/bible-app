import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final String id;
  final String bibleId;
  final String number;
  final String bookId;
  final String content;
  final String reference;
  final int verseCount;
  final String copyright;
  final String? nextChapterId;
  final String? previousChapterId;

  const Chapter({
    required this.id,
    required this.bibleId,
    required this.number,
    required this.bookId,
    required this.content,
    required this.reference,
    required this.verseCount,
    required this.copyright,
    this.nextChapterId,
    this.previousChapterId,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final next = json['next'] as Map<String, dynamic>?;
    final previous = json['previous'] as Map<String, dynamic>?;

    return Chapter(
      id: json['id'] ?? '',
      bibleId: json['bibleId'] ?? '',
      number: json['number'] ?? '',
      bookId: json['bookId'] ?? '',
      content: json['content'] ?? '',
      reference: json['reference'] ?? '',
      verseCount: (json['verseCount'] ?? 0) as int,
      copyright: json['copyright'] ?? '',
      nextChapterId: next?['id'],
      previousChapterId: previous?['id'],
    );
  }

  String get cleanContent => content.replaceAll(RegExp(r'<[^>]*>|[\n]'), '');

  @override
  List<Object?> get props => [
        id,
        bibleId,
        number,
        bookId,
        content,
        reference,
        verseCount,
        copyright,
        nextChapterId,
        previousChapterId,
      ];
}