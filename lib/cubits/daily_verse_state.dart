abstract class DailyVerseState {}

class DailyVerseInitial extends DailyVerseState {}

class DailyVerseLoading extends DailyVerseState {}

class DailyVerseSuccess extends DailyVerseState {
  final Map<String, dynamic> verseData;
  DailyVerseSuccess(this.verseData);
}

class DailyVerseError extends DailyVerseState {
  final String message;
  DailyVerseError(this.message);
}
