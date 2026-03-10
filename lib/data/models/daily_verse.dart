import 'package:equatable/equatable.dart';
import 'verse.dart';

class DailyVerse extends Equatable {
  final int day;
  final Verse verse;

  const DailyVerse({required this.day, required this.verse});

  String get cleanContent =>
      verse.content.replaceAll(RegExp(r'<[^>]*>|[\n]'), '');

  @override
  List<Object?> get props => [day, verse];
}
