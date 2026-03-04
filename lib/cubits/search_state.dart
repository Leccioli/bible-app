abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<dynamic> verses;
  SearchSuccess(this.verses);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
