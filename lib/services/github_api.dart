import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';
  static const int perPage = 10;

  Future<List<dynamic>> searchRepositories(String keyword, int page, String sortOrder) async {
    // Checkinh if cached data is available
    final cachedData = await _getCachedData(keyword, page, sortOrder);
    if (cachedData != null) {
      return cachedData;
    }

    // Fetching data from the API
    final response = await http.get(
      Uri.parse('$baseUrl/search/repositories?q=$keyword&page=$page&per_page=$perPage&sort=$sortOrder'),
      headers: {'Accept': 'application/vnd.github+json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // storing  the fetched data
      _cacheData(keyword, page, sortOrder, data['items']);

      return data['items'];
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future<void> _cacheData(String keyword, int page, String sortOrder, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateCacheKey(keyword, page, sortOrder);
    prefs.setString(key, json.encode(data));
  }

 Future<List<dynamic>?> _getCachedData(String keyword, int page, String sortOrder) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateCacheKey(keyword, page, sortOrder);
    final cachedData = prefs.getString(key);

    if (cachedData != null) {
      List<dynamic> results = json.decode(cachedData);

      // Sorting the cached data based on the provided sortOrder
      if (sortOrder == 'stars') {
        results.sort((a, b) => b['stargazers_count'].compareTo(a['stargazers_count']));
      } else if (sortOrder == 'updated') {
        results.sort((a, b) => DateTime.parse(b['pushed_at']).compareTo(DateTime.parse(a['pushed_at'])));
      }

      return results;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching and sorting cached results: $e');
    }
  }
  return null;
}


  String _generateCacheKey(String keyword, int page, String sortOrder) {
    return '$keyword:$page:$sortOrder';
  }
}
