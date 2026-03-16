import 'package:bible/core/constants.dart';
import 'package:bible/data/bible_api_client.dart';
import 'package:bible/data/daily_verses.dart';
import 'package:bible/data/models/bible.dart';
import 'package:bible/data/repositories/bible_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBibleApiClient extends Mock implements BibleApiClient {}

void main() {
  late MockBibleApiClient apiClient;
  late BibleRepository repository;

  setUp(() {
    apiClient = MockBibleApiClient();
    repository = BibleRepository(apiClient);
  });

  group('getBibles', () {
    test('return bibles from api client', () async {
      final bibles = [
        const Bible(id: '1', name: 'King James Version', abbreviation: 'KJV'),
      ];

      when(() => apiClient.fetchBibles()).thenAnswer((_) async => bibles);

      final result = await repository.getBibles();

      expect(result, bibles);
      verify(() => apiClient.fetchBibles()).called(1);
    });
  });

  group('searchKeyword', () {
    test('maps api response to SearchVerse list', () async {
      when(() => apiClient.searchKeyword('bible-id', 'grace')).thenAnswer(
        (_) async => {
          'verses': [
            {
              'id': 'ROM.3.24',
              'orgId': 'ROM.3.24',
              'bibleId': 'bible-id',
              'bookId': 'ROM',
              'chapterId': 'ROM.3',
              'text': 'Being justified freely by his grace...',
              'reference': 'Romans 3:24',
            },
          ],
        },
      );

      final result = await repository.searchKeyword('bible-id', 'grace');

      expect(result.length, 1);
      expect(result.first.reference, 'Romans 3:24');
      expect(result.first.text, contains('grace'));
      verify(() => apiClient.searchKeyword('bible-id', 'grace')).called(1);
    });
  });

  group('getVerse', () {
    test('maps api response to Verse model', () async {
      when(() => apiClient.fetchVerse('bible-id', 'JHN.3.16')).thenAnswer(
        (_) async => {
          'id': 'JHN.3.16',
          'orgId': 'JHN.3.16',
          'bibleId': 'bible-id',
          'bookId': 'JHN',
          'chapterId': 'JHN.3',
          'content': '<p>For God so loved the world...</p>',
          'reference': 'John 3:16',
          'verseCount': 1,
          'copyright': 'PUBLIC DOMAIN',
        },
      );

      final result = await repository.getVerse('bible-id', 'JHN.3.16');

      expect(result.id, 'JHN.3.16');
      expect(result.reference, 'John 3:16');
      verify(() => apiClient.fetchVerse('bible-id', 'JHN.3.16')).called(1);
    });
  });

  group('getDailyVerse', () {
    test('uses default bible id and wraps Verse in DailyVerse', () async {
      final expectedVerseId = getVerseOfTheDay();

      when(() => apiClient.fetchVerse(AppConstants.defaultBibleId, expectedVerseId))
          .thenAnswer(
        (_) async => {
          'id': expectedVerseId,
          'orgId': expectedVerseId,
          'bibleId': AppConstants.defaultBibleId,
          'bookId': 'JHN',
          'chapterId': 'JHN.3',
          'content': '<p>Daily verse content</p>',
          'reference': 'John 3:16',
          'verseCount': 1,
          'copyright': 'PUBLIC DOMAIN',
        },
      );

      final result = await repository.getDailyVerse();

      expect(result.day, DateTime.now().day);
      expect(result.verse.id, expectedVerseId);
      verify(() => apiClient.fetchVerse(AppConstants.defaultBibleId, expectedVerseId))
          .called(1);
    });
  });
}
