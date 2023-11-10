import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'diary_log_view.dart';
import 'average_rating_view.dart';
import 'package:dear_diary_app/view/auth_ui/diary_login_view.dart';

class WelcomePageView extends StatelessWidget {
  const WelcomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Dear Diary App'),
        // button to sign out and go to login page
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Get started with your daily journaling',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle Default List View button click
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiaryLogView()));
              },
              child: const Text('Default List View',
                  style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle Show Average Rating of Months button click
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AverageRatingView()));
              },
              child: const Text('Show Average Rating of Months',
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
