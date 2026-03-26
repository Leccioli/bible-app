import 'package:equatable/equatable.dart';
import '../../data/models/daily_verse.dart';

class DailyVerseState extends Equatable {
  final bool loading;
  final String? error;
  final DailyVerse? dailyVerse;

  const DailyVerseState({
    this.loading = false,
    this.error,
    this.dailyVerse,
  });

  DailyVerseState copyWith({
    bool? loading,
    String? error,
    DailyVerse? dailyVerse,
  }) {
    return DailyVerseState(
      loading: loading ?? this.loading,
      error: error,
      dailyVerse: dailyVerse ?? this.dailyVerse,
    );
  }

  @override
  List<Object?> get props => [loading, error, dailyVerse];
}
