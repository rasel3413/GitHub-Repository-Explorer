import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';
  static const int perPage = 10;

  Future<List<dynamic>> searchRepositories(String keyword, int page,String sortOrder) async {
    final response = await http.get(
      Uri.parse( '$baseUrl/search/repositories?q=$keyword&page=$page&per_page=$perPage&sort=$sortOrder'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['items'];
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
