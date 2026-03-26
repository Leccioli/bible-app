import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/bible_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final BibleRepository _repository;
  SearchCubit(this._repository) : super(const SearchState());

  Future<void> search(String bibleId, String query) async {
    if (query.isEmpty || bibleId.isEmpty) return;

    emit(state.copyWith(loading: true, error: null));
    try {
      final verses = await _repository.searchKeyword(bibleId, query);
      emit(state.copyWith(loading: false, verses: verses));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to search: $e'));
    }
  }
}
