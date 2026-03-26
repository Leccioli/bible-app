import 'package:bible/cubits/reader/reader_cubit.dart';
import 'package:bible/cubits/reader/reader_state.dart';
import 'package:bible/data/models/book.dart';
import 'package:bible/data/models/chapter.dart';
import 'package:bible/data/models/chapter_summary.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleRepository extends Mock implements BibleRepository {}

void main() {
  late MockBibleRepository repository;
  late ReaderCubit cubit;

  const bibleId = 'de4e12af7f28f599-02';

  const sampleBook = Book(
    id: 'GEN',
    bibleId: bibleId,
    abbreviation: 'Gen',
    name: 'Genesis',
    nameLong: 'The First Book of Moses Called Genesis',
  );

  final sampleBooks = [sampleBook];

  const sampleChapterSummary = ChapterSummary(
    id: 'GEN.1',
    bibleId: bibleId,
    number: '1',
    bookId: 'GEN',
    reference: 'Genesis 1',
  );

  final sampleChapters = [sampleChapterSummary];

  const sampleChapterWithNext = Chapter(
    id: 'GEN.1',
    bibleId: bibleId,
    number: '1',
    bookId: 'GEN',
    content: '<p><span class="v">1</span>In the beginning...</p>',
    reference: 'Genesis 1',
    verseCount: 31,
    copyright: 'PUBLIC DOMAIN',
    nextChapterId: 'GEN.2',
    previousChapterId: null,
  );

  const sampleChapterWithPrevious = Chapter(
    id: 'GEN.2',
    bibleId: bibleId,
    number: '2',
    bookId: 'GEN',
    content: '<p><span class="v">1</span>Thus the heavens...</p>',
    reference: 'Genesis 2',
    verseCount: 25,
    copyright: 'PUBLIC DOMAIN',
    nextChapterId: null,
    previousChapterId: 'GEN.1',
  );

  setUp(() {
    repository = MockBibleRepository();
    cubit = ReaderCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state is empty', () {
    expect(cubit.state, const ReaderState());
  });

  blocTest<ReaderCubit, ReaderState>(
    'emits loading then success when loadBooks succeeds',
    build: () {
      when(
        () => repository.getBooks(bibleId),
      ).thenAnswer((_) async => sampleBooks);
      return cubit;
    },
    act: (cubit) => cubit.loadBooks(bibleId),
    expect: () => [
      const ReaderState(
        loading: true,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: [],
        chapters: [],
        currentChapter: null,
      ),
      ReaderState(
        loading: false,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: sampleBooks,
        chapters: const [],
        currentChapter: null,
      ),
    ],
    verify: (_) {
      verify(() => repository.getBooks(bibleId)).called(1);
    },
  );

  blocTest<ReaderCubit, ReaderState>(
    'emits loading then error when loadBooks fails',
    build: () {
      when(
        () => repository.getBooks(bibleId),
      ).thenThrow(Exception('network down'));
      return cubit;
    },
    act: (cubit) => cubit.loadBooks(bibleId),
    expect: () => [
      const ReaderState(
        loading: true,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: [],
        chapters: [],
        currentChapter: null,
      ),
      isA<ReaderState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.error, 'error', contains('Failed to load books'))
          .having((s) => s.selectedBibleId, 'selectedBibleId', bibleId),
    ],
  );

  blocTest<ReaderCubit, ReaderState>(
    'emits loading then success when loadChapters succeeds',
    build: () {
      when(
        () => repository.getChapters(bibleId, sampleBook.id),
      ).thenAnswer((_) async => sampleChapters);
      return cubit;
    },
    seed: () => const ReaderState(selectedBibleId: bibleId),
    act: (cubit) => cubit.loadChapters(sampleBook),
    expect: () => [
      const ReaderState(
        loading: true,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: [],
        chapters: [],
        currentChapter: null,
      ),
      ReaderState(
        loading: false,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: sampleBook,
        books: const [],
        chapters: sampleChapters,
        currentChapter: null,
      ),
    ],
    verify: (_) {
      verify(() => repository.getChapters(bibleId, sampleBook.id)).called(1);
    },
  );

  blocTest<ReaderCubit, ReaderState>(
    'emits loading then success when loadChapter succeeds',
    build: () {
      when(
        () => repository.getChapter(bibleId, 'GEN.1'),
      ).thenAnswer((_) async => sampleChapterWithNext);
      return cubit;
    },
    seed: () => const ReaderState(selectedBibleId: bibleId),
    act: (cubit) => cubit.loadChapter('GEN.1'),
    expect: () => [
      const ReaderState(
        loading: true,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: [],
        chapters: [],
        currentChapter: null,
      ),
      const ReaderState(
        loading: false,
        error: null,
        selectedBibleId: bibleId,
        selectedBook: null,
        books: [],
        chapters: [],
        currentChapter: sampleChapterWithNext,
      ),
    ],
    verify: (_) {
      verify(() => repository.getChapter(bibleId, 'GEN.1')).called(1);
    },
  );

  blocTest<ReaderCubit, ReaderState>(
    'loadNextChapter does nothing when nextChapterId is null',
    build: () => cubit,
    seed: () => const ReaderState(
      selectedBibleId: bibleId,
      currentChapter: sampleChapterWithPrevious,
    ),
    act: (cubit) => cubit.loadNextChapter(),
    expect: () => <ReaderState>[],
    verify: (_) {
      verifyNever(() => repository.getChapter(any(), any()));
    },
  );

  blocTest<ReaderCubit, ReaderState>(
    'loadPreviousChapter does nothing when previousChapterId is null',
    build: () => cubit,
    seed: () => const ReaderState(
      selectedBibleId: bibleId,
      currentChapter: sampleChapterWithNext,
    ),
    act: (cubit) => cubit.loadPreviousChapter(),
    expect: () => <ReaderState>[],
    verify: (_) {
      verifyNever(() => repository.getChapter(any(), any()));
    },
  );
}
