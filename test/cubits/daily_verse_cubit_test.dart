import 'package:bible/cubits/daily_verse/daily_verse_cubit.dart';
import 'package:bible/cubits/daily_verse/daily_verse_state.dart';
import 'package:bible/data/models/daily_verse.dart';
import 'package:bible/data/models/verse.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleRepository extends Mock implements BibleRepository {}

void main() {
    late MockBibleRepository repository;
    late DailyVerseCubit cubit;

    setUp(() {
        repository = MockBibleRepository();
        cubit = DailyVerseCubit(repository);
    });

    tearDown(() async {
        await cubit.close();
    });

    final sampleDailyVerse = DailyVerse(
    day: 10,
    verse: const Verse(
      id: 'JHN.3.16',
      orgId: 'JHN.3.16',
      bibleId: 'de4e12af7f28f599-02',
      bookId: 'JHN',
      chapterId: 'JHN.3',
      content: '<p>For God so loved the world...</p>',
      reference: 'John 3:16',
      verseCount: 1,
      copyright: 'PUBLIC DOMAIN',
    ),
  );

    test('initial state is empty', () {
        expect(cubit.state, const DailyVerseState());
    });

    blocTest<DailyVerseCubit, DailyVerseState>(
        'emits loading then success when fetchDailyVerse succeeds',
        build: () {
            when(() => repository.getDailyVerse()).thenAnswer((_) async => sampleDailyVerse);
            return cubit;
        },
        act: (cubit) => cubit.fetchDailyVerse(),
        expect: () => [
            const DailyVerseState(loading: true, error: null, dailyVerse: null),
            DailyVerseState(loading: false, error: null, dailyVerse: sampleDailyVerse),
        ],
        verify: (_) {
            verify(() => repository.getDailyVerse()).called(1);
        },
    );

    blocTest<DailyVerseCubit, DailyVerseState>(
        'emits loading then error when fetchDailyVerse fails',
        build: () {
            when(() => repository.getDailyVerse()).thenThrow(Exception('daily verse error'));
            return cubit;
        },
        act: (cubit) => cubit.fetchDailyVerse(),
        expect: () => [
            const DailyVerseState(loading: true, error: null, dailyVerse: null),
            isA<DailyVerseState>()
                .having((s) => s.loading, 'loading', false)
                .having((s) => s.error, 'error', contains('Failed to load daily verse'))
                .having((s) => s.dailyVerse, 'dailyVerse', isNull),
        ],
    );
}