import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RepositoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> repository;
  final DateFormat _dateFormat = DateFormat('MMMM dd, yyyy hh:mm a');

  RepositoryDetailsPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repository['full_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(repository['owner']['avatar_url']),
                radius: 50,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Owner: ${repository['owner']['login']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${repository['description'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Last Updated: ${_formatDateTime(repository['updated_at'])}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    return _dateFormat.format(dateTime);
  }
}
