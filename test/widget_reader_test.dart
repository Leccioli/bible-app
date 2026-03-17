import 'package:bible/cubits/reader_cubit.dart';
import 'package:bible/cubits/reader_state.dart';
import 'package:bible/data/models/chapter.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:bible/ui/reader_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleRepository extends Mock implements BibleRepository {}

void main() {
  group('ReaderPage Widget Tests', () {
    late MockBibleRepository repository;
    late ReaderCubit cubit;

    const chapter = Chapter(
      id: 'GEN.1',
      bibleId: 'bible-id',
      number: '1',
      bookId: 'GEN',
      content: '<p><span class="v">1</span>In the beginning...</p>',
      reference: 'Genesis 1',
      verseCount: 31,
      copyright: 'PUBLIC DOMAIN',
      nextChapterId: 'GEN.2',
      previousChapterId: null,
    );

    const chapterNoNext = Chapter(
      id: 'REV.22',
      bibleId: 'bible-id',
      number: '22',
      bookId: 'REV',
      content: '<p><span class="v">21</span>The grace of our Lord...</p>',
      reference: 'Revelation 22',
      verseCount: 21,
      copyright: 'PUBLIC DOMAIN',
      nextChapterId: null,
      previousChapterId: 'REV.21',
    );

    setUp(() {
      repository = MockBibleRepository();
      cubit = ReaderCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    testWidgets('displays chapter content correctly', (
      WidgetTester tester,
    ) async {
      cubit.emit(const ReaderState(currentChapter: chapter));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReaderCubit>.value(
            value: cubit,
            child: const ReaderPage(),
          ),
        ),
      );

      expect(find.byType(Html), findsOneWidget);

      expect(find.text('Genesis 1'), findsWidgets);

      expect(find.text('No chapter loaded'), findsNothing);
    });

    testWidgets('Next button is disabled when nextChapterId is null', (
      WidgetTester tester,
    ) async {
      cubit.emit(const ReaderState(currentChapter: chapterNoNext));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReaderCubit>.value(
            value: cubit,
            child: const ReaderPage(),
          ),
        ),
      );

      final nextButton = find.byWidgetPredicate(
        (widget) => widget is ElevatedButton && widget.onPressed == null,
      );
      expect(nextButton, findsOneWidget);
    });

    testWidgets('Previous button is disabled when previousChapterId is null', (
      WidgetTester tester,
    ) async {
      cubit.emit(const ReaderState(currentChapter: chapter));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReaderCubit>.value(
            value: cubit,
            child: const ReaderPage(),
          ),
        ),
      );

      final previousButton = find.byWidgetPredicate(
        (widget) => widget is OutlinedButton && widget.onPressed == null,
      );
      expect(previousButton, findsOneWidget);
    });

    testWidgets('loading indicator appears when isNavigating is true', (
      WidgetTester tester,
    ) async {
      cubit.emit(const ReaderState(loading: true, currentChapter: chapter));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReaderCubit>.value(
            value: cubit,
            child: const ReaderPage(),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      expect(find.text('Loading...'), findsWidgets);
    });

    testWidgets('navigation buttons have proper text when not loading', (
      WidgetTester tester,
    ) async {
      cubit.emit(const ReaderState(currentChapter: chapter));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ReaderCubit>.value(
            value: cubit,
            child: const ReaderPage(),
          ),
        ),
      );

      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      expect(find.text('Loading...'), findsNothing);
    });
  });
}
