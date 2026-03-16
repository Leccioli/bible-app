import 'package:bible/cubits/bible_cubit.dart';
import 'package:bible/cubits/bible_state.dart';
import 'package:bible/data/models/bible.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleRepository extends Mock implements BibleRepository {}

void main() {
  late MockBibleRepository repository;
  late BibleCubit cubit;

  setUp(() {
    repository = MockBibleRepository();
    cubit = BibleCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  final sampleBibles = [
    Bible(id: '1', name: 'King James Version', abbreviation: 'KJV'),
    Bible(id: '2', name: 'New International Version', abbreviation: 'NIV'),
  ];

  test('initial state is empty', () {
    expect(cubit.state, const BibleState());
  });

  blocTest<BibleCubit, BibleState>(
    'emits loading then success when loadBibles succeeds',
    build: () {
      when(() => repository.getBibles()).thenAnswer((_) async => sampleBibles);
      return cubit;
    },
    act: (cubit) => cubit.loadBibles(),
    expect: () => [
      const BibleState(loading: true, error: null, bibles: []),
      BibleState(loading: false, error: null, bibles: sampleBibles),
    ],
    verify: (_) {
      verify(() => repository.getBibles()).called(1);
    },
  );

  blocTest<BibleCubit, BibleState>(
    'emits loading then error when loadBibles fails',
    build: () {
      when(() => repository.getBibles()).thenThrow(Exception('network down'));
      return cubit;
    },
    act: (cubit) => cubit.loadBibles(),
    expect: () => [
      const BibleState(loading: true, error: null, bibles: []),
      isA<BibleState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.error, 'error', contains('network down'))
          .having((s) => s.bibles, 'bibles', []),
    ],
  );
}
