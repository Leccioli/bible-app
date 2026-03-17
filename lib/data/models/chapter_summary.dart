import 'package:equatable/equatable.dart';

class ChapterSummary extends Equatable {
  final String id;
  final String bibleId;
  final String number;
  final String bookId;
  final String reference;

  const ChapterSummary({
    required this.id,
    required this.bibleId,
    required this.number,
    required this.bookId,
    required this.reference,
  });

  factory ChapterSummary.fromJson(Map<String, dynamic> json) {
    return ChapterSummary(
      id: json['id'] ?? '',
      bibleId: json['bibleId'] ?? '',
      number: json['number'] ?? '',
      bookId: json['bookId'] ?? '',
      reference: json['reference'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, bibleId, number, bookId, reference];
}