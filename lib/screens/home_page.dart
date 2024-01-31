import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:repository_explorer/models/home_model.dart';

import '../constants/strings.dart';
import 'repository_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      ///Appbar
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        centerTitle: true,
      ),

      
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),

            ///Sorting options 
            Align(
              alignment: Alignment.topRight,
              child: DropdownButtonHideUnderline(
                child: Container(
                  alignment: Alignment.topRight,
                  width: 150,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    value: Provider.of<HomeModel>(context).sortOrder,
                    items: ['best match', 'stars', 'updated']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      Provider.of<HomeModel>(context, listen: false)
                          .updateSortOrder(newValue!);
                    },
                  ),
                ),
              ),
            ),



            Expanded(
              child: Stack(
                children: [

                  ///Checking is loading for showing progress bar
                  if (Provider.of<HomeModel>(context,listen: false).isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),

                    ///Checking if the list reached to bottom
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        Provider.of<HomeModel>(context, listen: false)
                            .performSearch(false);

                        return true;
                      }
                      return false;
                    },
                  ///Building the Listtile of information of github repo
                    child: Consumer<HomeModel>(
                      builder: (context, homeModel, child) {
                        return ListView.builder(
                          itemCount: homeModel.searchResults.length,
                          itemBuilder: (context, index) {
                            final repo = homeModel.searchResults[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(40),
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.black38),
                              ),
                              child: ListTile(
                                title: Text(repo['full_name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Stars: ${repo['stargazers_count']}',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    Text('Owner: ${repo['owner']['login']}',
                                        style: GoogleFonts.openSans()),
                                    Text(
                                        'Last Updated: ${homeModel.formatDateTime(repo['pushed_at'])}',
                                        style: GoogleFonts.openSans()),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(repo['owner']['avatar_url']),
                                ),
                                onTap: () {
                                  _navigateToRepositoryDetails(context, repo);
                                },
                              ),
                            );
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
      ),
    );
  }
///Navigations to details page
  void _navigateToRepositoryDetails(
      BuildContext context, Map<String, dynamic> repo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryDetailsPage(repository: repo),
      ),
    );
  }
}
