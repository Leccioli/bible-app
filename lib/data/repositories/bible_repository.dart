import '../bible_api_client.dart';
import '../daily_verses.dart';
import '../models/bible.dart';
import '../models/daily_verse.dart';
import '../models/search_verse.dart';
import '../models/verse.dart';
import '../../core/constants.dart';

class BibleRepository {
  final BibleApiClient _apiClient;

  BibleRepository(this._apiClient);

  Future<List<Bible>> getBibles() async {
    return await _apiClient.fetchBibles();
  }

  Future<List<SearchVerse>> searchKeyword(String bibleId, String query) async {
    final data = await _apiClient.searchKeyword(bibleId, query);
    final verses = data['verses'] as List<dynamic>? ?? [];
    return verses.map((v) => SearchVerse.fromJson(v)).toList();
  }

  Future<Verse> getVerse(String bibleId, String verseId) async {
    final data = await _apiClient.fetchVerse(bibleId, verseId);
    return Verse.fromJson(data);
  }

  Future<DailyVerse> getDailyVerse() async {
    final today = DateTime.now().day;
    final verseId = getVerseOfTheDay();
    final verse = await getVerse(AppConstants.defaultBibleId, verseId);
    return DailyVerse(day: today, verse: verse);
  }
}
