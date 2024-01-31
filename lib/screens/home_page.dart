import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/strings.dart';
import '../services/github_api.dart';
import 'package:intl/intl.dart';

import 'repository_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _searchResults = [];
  int _currentPage = 1;
  bool _isLoading = false;
  String keyword = "";
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  String sortOrder = "stars";
  final TextEditingController _searchingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.openSans(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchingController,
                    decoration: InputDecoration(
                      labelText: 'Enter your text',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              keyword = _searchingController.text;
                            });
                            _performSearch();
                          },
                          icon: Icon(Icons.search)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonHideUnderline(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: sortOrder,
                items: [
                  'best match',
                  'stars',
                  'forks',
                  'help-wanted-issues',
                  'updated'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sortOrder = newValue!;
                  });
                  _performSearch();
                },
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                NotificationListener<ScrollNotification>(
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stars: ${repo['stargazers_count']}'),
                            Text('Owner: ${repo['owner']['login']}'),
                            Text(
                                'Last Updated: ${_formatDateTime(repo['updated_at'])}'),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(repo['owner']['avatar_url']),
                        ),
                        onTap: () {
                          _navigateToRepositoryDetails(repo);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    return _dateFormat.format(dateTime);
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
      _searchResults.clear(); 
    });

   
    final results = await GitHubApiService()
        .searchRepositories(keyword, _currentPage, sortOrder);

    final List<Map<String, dynamic>> repositories =
        List.castFrom<dynamic, Map<String, dynamic>>(results);

    setState(() {
      _searchResults.addAll(repositories);
      _currentPage++;
      _isLoading = false;
    });
  }

  void _navigateToRepositoryDetails(Map<String, dynamic> repo) {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RepositoryDetailsPage(repository:repo),
    ),
  ); }
}
