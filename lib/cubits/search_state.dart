import 'package:equatable/equatable.dart';
import '../data/models/search_verse.dart';

class SearchState extends Equatable {
  final bool loading;
  final String? error;
  final List<SearchVerse> verses;

  const SearchState({this.loading = false, this.error, this.verses = const []});

  SearchState copyWith({
    bool? loading,
    String? error,
    List<SearchVerse>? verses,
  }) {
    return SearchState(
      loading: loading ?? this.loading,
      error: error,
      verses: verses ?? this.verses,
    );
  }

  @override
  List<Object?> get props => [loading, error, verses];
}
