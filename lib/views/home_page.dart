import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/activity_model.dart';
import '/views/moods_page.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';  // Import the UserProvider
import 'bottom_navigation_bar.dart';

class MyHomePage extends StatelessWidget {
  final String userId;  // Accept userId as a parameter

  const MyHomePage({super.key, required this.userId});  // Constructor with userId

  Future<String> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[0]['q'];
      } else {
        return "Error: Unable to fetch quote. (${response.statusCode})";
      }
    } catch (error) {
      return "An error occurred: $error";
    }
  }

  Future<List<Activity>> getActivities(selectedMood) async {
    final repository = ActivityRepository();
    return await repository.fetchActivities(selectedMood);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMood = Provider.of<MoodProvider>(context).selectedMood;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quote of the Day title
            const Text(
              "Quote of the Day!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),

            // Display the quote
            FutureBuilder<String>(
              future: fetchQuote(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      snapshot.data ?? "No quote available",
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),

            // Divider between quote and activities
            const Divider(
              color: Colors.blueAccent,
              thickness: 1,
              height: 24.0,
            ),

            // Display the list of activities
            Expanded(
              child: FutureBuilder<List<Activity>>(
                future: getActivities(selectedMood),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No activities available.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    final activities = snapshot.data!;
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            title: Text(
                              activity.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(activity.description),
                            trailing: Text(
                              activity.category,
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
