import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:repository_explorer/constants/strings.dart';
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

  ///Update using key word for future work 

  void updateKeyword(String newKeyword) {
    _keyword = newKeyword;
    _currentPage = 1;
    performSearch(false);
    notifyListeners();
  }

  ///Sorting the list 

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

      if (clear) _searchResults.clear();
      notifyListeners();
      _isLoading = true;

      // Check connectivity status
  
        // Fetch data from the network
        final results = await GitHubApiService()
            .searchRepositories(_keyword, _currentPage, _sortOrder);

        final List<Map<String, dynamic>> repositories =
            List.castFrom<dynamic, Map<String, dynamic>>(results);

        _searchResults.addAll(repositories);
        _currentPage++;

        // Cache the results for offline browsing
       
     
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



  ///Formating Last updated date
  String formatDateTime(String timestamp) {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy hh:mm a', 'en_US');
    final DateTime dateTime = DateTime.parse(timestamp);
    return dateFormat.format(dateTime.toLocal());
  }
}
