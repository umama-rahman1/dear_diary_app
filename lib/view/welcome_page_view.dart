import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'average_rating_view.dart';
import 'diary_log_firebase_view.dart';
import '../main.dart';

class WelcomePageView extends StatelessWidget {
  const WelcomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Dear Diary App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
          DarkModeToggle(), // Include the DarkModeToggle widget here
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryLogFirebaseView(),
                  ),
                );
              },
              child: const Text(
                'Default List View',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AverageRatingView(),
                  ),
                );
              },
              child: const Text(
                'Statistics & Insights',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DarkModeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Switch(
      value: isDarkMode,
      onChanged: (value) {
        ThemeMode newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
        MyApp.of(context).changeTheme(newThemeMode);
      },
    );
  }
}
