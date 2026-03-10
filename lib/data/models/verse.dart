import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final String id;
  final String orgId;
  final String bibleId;
  final String bookId;
  final String chapterId;
  final String content;
  final String reference;
  final int verseCount;
  final String copyright;

  const Verse({
    required this.id,
    required this.orgId,
    required this.bibleId,
    required this.bookId,
    required this.chapterId,
    required this.content,
    required this.reference,
    required this.verseCount,
    required this.copyright,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] ?? '',
      orgId: json['orgId'] ?? '',
      bibleId: json['bibleId'] ?? '',
      bookId: json['bookId'] ?? '',
      chapterId: json['chapterId'] ?? '',
      content: json['content'] ?? '',
      reference: json['reference'] ?? '',
      verseCount: json['verseCount'] ?? 0,
      copyright: json['copyright'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, orgId, bibleId, bookId, chapterId, content, reference, verseCount, copyright];
}
