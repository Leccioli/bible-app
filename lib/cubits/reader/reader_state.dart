import 'package:equatable/equatable.dart';
import '../../data/models/book.dart';
import '../../data/models/chapter.dart';
import '../../data/models/chapter_summary.dart';

class ReaderState extends Equatable {
  final bool loading;
  final String? error;
  final String? selectedBibleId;
  final Book? selectedBook;
  final List<Book> books;
  final List<ChapterSummary> chapters;
  final Chapter? currentChapter;

  const ReaderState({
    this.loading = false,
    this.error,
    this.selectedBibleId,
    this.selectedBook,
    this.books = const [],
    this.chapters = const [],
    this.currentChapter,
  });

  ReaderState copyWith({
    bool? loading,
    String? error,
    String? selectedBibleId,
    Book? selectedBook,
    List<Book>? books,
    List<ChapterSummary>? chapters,
    Chapter? currentChapter,
    bool clearError = false,
    bool clearSelectedBook = false,
    bool clearCurrentChapter = false,
  }) {
    return ReaderState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      selectedBibleId: selectedBibleId ?? this.selectedBibleId,
      selectedBook: clearSelectedBook ? null : (selectedBook ?? this.selectedBook),
      books: books ?? this.books,
      chapters: chapters ?? this.chapters,
      currentChapter: clearCurrentChapter ? null : (currentChapter ?? this.currentChapter),
    );
  }

  @override
  List<Object?> get props => [
        loading,
        error,
        selectedBibleId,
        selectedBook,
        books,
        chapters,
        currentChapter,
      ];
}