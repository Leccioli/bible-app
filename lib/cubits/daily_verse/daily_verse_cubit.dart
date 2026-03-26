import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/bible_repository.dart';
import 'daily_verse_state.dart';

class DailyVerseCubit extends Cubit<DailyVerseState> {
  final BibleRepository _repository;

  DailyVerseCubit(this._repository) : super(const DailyVerseState());

  Future<void> fetchDailyVerse() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final dailyVerse = await _repository.getDailyVerse();
      emit(state.copyWith(loading: false, dailyVerse: dailyVerse));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load daily verse: $e'));
    }
  }
}
