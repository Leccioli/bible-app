import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/book.dart';
import '../../data/repositories/bible_repository.dart';
import 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  final BibleRepository _repository;

  ReaderCubit(this._repository) : super(const ReaderState());

  void selectBible(String bibleId) {
    emit(ReaderState(selectedBibleId: bibleId));
  }

  Future<void> loadBooks(String bibleId) async {
    emit(
      state.copyWith(
        loading: true,
        selectedBibleId: bibleId,
        books: const [],
        chapters: const [],
        clearError: true,
        clearSelectedBook: true,
        clearCurrentChapter: true,
      ),
    );

    try {
      final books = await _repository.getBooks(bibleId);
      emit(state.copyWith(loading: false, books: books));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load books: $e'));
    }
  }

  Future<void> loadChapters(Book book) async {
    final bibleId = state.selectedBibleId;
    if (bibleId == null) return;

    emit(
      state.copyWith(
        loading: true,
        selectedBook: book,
        chapters: const [],
        currentChapter: null,
        clearError: true,
        clearSelectedBook: true,
        clearCurrentChapter: true,
      ),
    );

    try {
      final chapters = await _repository.getChapters(bibleId, book.id);
      emit(
        state.copyWith(loading: false, selectedBook: book, chapters: chapters),
      );
    } catch (e) {
      emit(
        state.copyWith(loading: false, error: 'Failed to load chapters: $e'),
      );
    }
  }

  Future<void> loadChapter(String chapterId) async {
    final bibleId = state.selectedBibleId;
    if (bibleId == null) return;

    emit(state.copyWith(loading: true, clearError: true));

    try {
      final chapter = await _repository.getChapter(bibleId, chapterId);
      emit(state.copyWith(loading: false, currentChapter: chapter));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load chapter: $e'));
    }
  }

  Future<void> loadNextChapter() async {
    final nextChapterId = state.currentChapter?.nextChapterId;
    if (nextChapterId == null) return;

    await loadChapter(nextChapterId);
  }

  Future<void> loadPreviousChapter() async {
    final previousChapterId = state.currentChapter?.previousChapterId;
    if (previousChapterId == null) return;

    await loadChapter(previousChapterId);
  }
}
