import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/bible_api_client.dart';
import '../data/daily_verses.dart';
import 'daily_verse_state.dart';

class DailyVerseCubit extends Cubit<DailyVerseState> {
  final BibleApiClient apiClient;
  final String _kjvBibleId = 'de4e12af7f28f599-02';

  DailyVerseCubit(this.apiClient) : super(DailyVerseInitial());

  Future<void> fetchDailyVerse() async {
    emit(DailyVerseLoading());
    try {
      final verseId = getVerseOfTheDay();
      final data = await apiClient.fetchVerse(_kjvBibleId, verseId);
      emit(DailyVerseSuccess(data));
    } catch (e) {
      emit(DailyVerseError('Failed to load daily verse: $e'));
    }
  }
}
