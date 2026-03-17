import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import 'models/bible.dart';
import 'models/book.dart';
import 'models/chapter.dart';
import 'models/chapter_summary.dart';
import 'secrets.dart';

class BibleApiClient {
  final String _baseUrl = AppConstants.apiBaseUrl;
  final String _apiKey = apiKey;

  Future<List<Bible>> fetchBibles() async {
    final url = Uri.parse('$_baseUrl/v1/bibles');
    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final bibles = await Isolate.run(() => _processJson(response.body));
      return bibles;
    } else {
      throw Exception('Failed to load bibles: ${response.statusCode}');
    }
  }

  Future<List<Book>> fetchBooks(String bibleId) async {
    final url = Uri.parse('$_baseUrl/v1/bibles/$bibleId/books');
    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      final rawBooks = parsedData['data'] as List<dynamic>? ?? [];
      final books = rawBooks.map((json) => Book.fromJson(json)).toList();
      books.sort((a, b) => a.name.compareTo(b.name));
      return books;
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<List<ChapterSummary>> fetchChapters(
    String bibleId,
    String bookId,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/v1/bibles/$bibleId/books/$bookId/chapters',
    );
    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      final rawChapters = parsedData['data'] as List<dynamic>? ?? [];
      return rawChapters.map((json) => ChapterSummary.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chapters: ${response.statusCode}');
    }
  }

  Future<Chapter> fetchChapter(String bibleId, String chapterId) async {
    final url = Uri.parse('$_baseUrl/v1/bibles/$bibleId/chapters/$chapterId');
    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      final rawChapter = parsedData['data'] as Map<String, dynamic>;
      return Chapter.fromJson(rawChapter);
    } else {
      throw Exception('Failed to load chapter: ${response.statusCode}');
    }
  }

  Future<dynamic> searchKeyword(String bibleId, String query) async {
    final url = Uri.parse(
      '$_baseUrl/v1/bibles/$bibleId/search?query=$query&limit=50',
    );

    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      debugPrint(
        'Found: ${parsedData['data']['total']} verses for query "$query" in Bible ID "$bibleId".',
      );
      return parsedData['data'];
    } else {
      throw Exception('Failed to search keyword: ${response.statusCode}');
    }
  }

  Future<dynamic> fetchVerse(String bibleId, String verseId) async {
    final url = Uri.parse('$_baseUrl/v1/bibles/$bibleId/verses/$verseId');

    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      return parsedData['data'];
    } else {
      throw Exception('Failed to fetch verse: ${response.statusCode}');
    }
  }

  List<Bible> _processJson(String responseBody) {
    final decodedData = jsonDecode(responseBody);
    final rawBibles = decodedData['data'] as List;
    List<Bible> bibles = rawBibles.map((json) => Bible.fromJson(json)).toList();
    bibles.sort((a, b) => a.name.compareTo(b.name));
    return bibles;
  }
}
