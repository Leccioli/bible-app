import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import '../data/models/bible.dart';
import 'secrets.dart';

class BibleApiClient {
  final String _baseUrl = 'https://rest.api.bible';
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

  Future<dynamic> searchKeyWord(String bibleId, String query) async {
    final url = Uri.parse(
      '$_baseUrl/v1/bibles/$bibleId/search?query=$query&limit=50',
    );

    final response = await http.get(url, headers: {'api-key': _apiKey});

    if (response.statusCode == 200) {
      final parsedData = await Isolate.run(() => jsonDecode(response.body));
      print(
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
