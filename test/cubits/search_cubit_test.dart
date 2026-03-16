import 'package:bible/cubits/search_cubit.dart';
import 'package:bible/cubits/search_state.dart';
import 'package:bible/data/models/search_verse.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleRepository extends Mock implements BibleRepository {}

void main() {
  late MockBibleRepository repository;
  late SearchCubit cubit;

  setUp(() {
    repository = MockBibleRepository();
    cubit = SearchCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  const bibleId = 'de4e12af7f28f599-02';
  const query = 'faith';

  final sampleVerses = [
    const SearchVerse(
      id: 'ROM.10.17',
      orgId: 'ROM.10.17',
      bibleId: bibleId,
      bookId: 'ROM',
      chapterId: 'ROM.10',
      text: 'So then faith cometh by hearing...',
      reference: 'Romans 10:17',
    ),
  ];

  test('initial state is empty', () {
    expect(cubit.state, const SearchState());
  });

  blocTest<SearchCubit, SearchState>(
    'emits nothing when query is empty',
    build: () => cubit,
    act: (cubit) => cubit.search(bibleId, ''),
    expect: () => <SearchState>[],
    verify: (_) {
      verifyNever(() => repository.searchKeyword(any(), any()));
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits loading then success when search succeeds',
    build: () {
      when(
        () => repository.searchKeyword(bibleId, query),
      ).thenAnswer((_) async => sampleVerses);
      return cubit;
    },
    act: (cubit) => cubit.search(bibleId, query),
    expect: () => [
      const SearchState(loading: true, error: null, verses: []),
      SearchState(loading: false, error: null, verses: sampleVerses),
    ],
    verify: (_) {
      verify(() => repository.searchKeyword(bibleId, query)).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits loading then error when search fails',
    build: () {
      when(
        () => repository.searchKeyword(bibleId, query),
      ).thenThrow(Exception('search failed'));
      return cubit;
    },
    act: (cubit) => cubit.search(bibleId, query),
    expect: () => [
      const SearchState(loading: true, error: null, verses: []),
      isA<SearchState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.error, 'error', contains('Failed to search'))
          .having((s) => s.verses, 'verses', isEmpty),
    ],
  );
}
