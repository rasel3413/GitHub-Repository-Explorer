import 'package:flutter/material.dart';

import '../services/github_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _searchResults = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repository Explorer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _performSearch,
              child: Text('Search Repositories'),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // Reached the bottom of the list
                  _performSearch();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final repo = _searchResults[index];
                  return ListTile(
                    title: Text(repo['full_name']),
                    subtitle: Text(
                        'Stars: ${repo['stargazers_count']} | Owner: ${repo['owner']['login']}'),
                    onTap: () {
                      // Navigate to repository details page
                      _navigateToRepositoryDetails(repo);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    // Replace 'flutter' with your chosen keyword
    final keyword = 'flutter';

    // Call your GitHub API service to search for repositories
    // You can replace this with your actual API call
    final results =
        await GitHubApiService().searchRepositories(keyword, _currentPage);

    // Explicitly cast the results to List<Map<String, dynamic>>
    final List<Map<String, dynamic>> repositories =
        List.castFrom<dynamic, Map<String, dynamic>>(results);

    setState(() {
      _searchResults.addAll(repositories);
      _currentPage++;
      _isLoading = false;
    });
  }

  void _navigateToRepositoryDetails(Map<String, dynamic> repo) {
    // Implement navigation to repository details page
    // You can use Navigator to push a new page
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => RepositoryDetailsPage(repo)));
  }
}
