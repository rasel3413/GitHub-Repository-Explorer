import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:repository_explorer/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/github_api.dart';

class HomeModel extends ChangeNotifier {
  List<Map<String, dynamic>> _searchResults = [];
  int _currentPage = 1;
  bool _isLoading = false;
  String _keyword = AppStrings.keyWord;
  String _sortOrder = "best match";

  List<Map<String, dynamic>> get searchResults => _searchResults;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String get keyword => _keyword;
  String get sortOrder => _sortOrder;

  HomeModel() {
    initialize();
  }

  Future<void> initialize() async {
    await performSearch(true);
  }

  void updateKeyword(String newKeyword) {
    _keyword = newKeyword;
    _currentPage = 1;
    performSearch(false);
    notifyListeners();
  }

  void updateSortOrder(String newSortOrder) {
    _sortOrder = newSortOrder;
    _currentPage = 1;
    performSearch(true);
    notifyListeners();
  }

  Future<void> performSearch(bool clear) async {
    if (_isLoading) {
      return;
    }

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (clear) _searchResults.clear();
      notifyListeners();
      _isLoading = true;

      // Check connectivity status
      if (connectivityResult != ConnectivityResult.none) {
        // Fetch data from the network
        final results = await GitHubApiService()
            .searchRepositories(_keyword, _currentPage, _sortOrder);

        final List<Map<String, dynamic>> repositories =
            List.castFrom<dynamic, Map<String, dynamic>>(results);

        _searchResults.addAll(repositories);
        _currentPage++;

        // Cache the results for offline browsing
        await cacheResults(json.encode(_searchResults));
      } else {
        // If offline, check for cached data
        final cachedResults = await getCachedResults();
        if (cachedResults != null) {
          _searchResults.addAll(
            cachedResults.cast<Map<String, dynamic>>(),
          ); // Explicit casting
        } else {
          // Handle no cached data for offline mode
          print('No cached data available for offline mode');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during search: $e');
      }
      // Handle error as needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>?> getCachedResults() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cachedResults = prefs.getString('cachedResults');

      if (cachedResults != null) {
        final List<dynamic> results = json.decode(cachedResults);
        return results;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cached results: $e');
      }
    }
    return null;
  }

  Future<void> cacheResults(String results) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedResults', results);
    } catch (e) {
      if (kDebugMode) {
        print('Error caching results: $e');
      }
    }
  }

  ///Formating Last updated date
  String formatDateTime(String timestamp) {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy hh:mm a', 'en_US');
    final DateTime dateTime = DateTime.parse(timestamp);
    return dateFormat.format(dateTime.toLocal());
  }
}
