import 'package:flutter/material.dart';
import 'diary_log_view.dart';
import 'average_rating_view.dart';

class WelcomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Dear Diary App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Get started with your daily journaling',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle Default List View button click
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DiaryLogView()));
              },
              child: Text('Default List View', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle Show Average Rating of Months button click
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AverageRatingView()));
              },
              child: Text('Show Average Rating of Months',
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
