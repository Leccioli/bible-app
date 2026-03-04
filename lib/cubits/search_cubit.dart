import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/bible_api_client.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final BibleApiClient _apiClient;
  SearchCubit(this._apiClient) : super(SearchInitial());

  Future<void> search(String bibleId, String query) async {
    if (query.isEmpty || bibleId.isEmpty) return;

    emit(SearchLoading());
    try {
      final data = await _apiClient.searchKeyWord(bibleId, query);
      final verses = data['verses'] as List<dynamic>? ?? [];
      emit(SearchSuccess(verses));
    } catch (e) {
      emit(SearchError('Failed to search: $e'));
    }
  }
}
