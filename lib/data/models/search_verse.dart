import 'package:equatable/equatable.dart';

class SearchVerse extends Equatable {
  final String id;
  final String orgId;
  final String bibleId;
  final String bookId;
  final String chapterId;
  final String text;
  final String reference;

  const SearchVerse({
    required this.id,
    required this.orgId,
    required this.bibleId,
    required this.bookId,
    required this.chapterId,
    required this.text,
    required this.reference,
  });

  factory SearchVerse.fromJson(Map<String, dynamic> json) {
    return SearchVerse(
      id: json['id'] ?? '',
      orgId: json['orgId'] ?? '',
      bibleId: json['bibleId'] ?? '',
      bookId: json['bookId'] ?? '',
      chapterId: json['chapterId'] ?? '',
      text: (json['text'] ?? '').replaceAll('\n', ''),
      reference: json['reference'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    orgId,
    bibleId,
    bookId,
    chapterId,
    text,
    reference,
  ];
}
