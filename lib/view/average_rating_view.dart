import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';

class AverageRatingView extends StatefulWidget {
  @override
  _AverageRatingViewState createState() => _AverageRatingViewState();
}

class _AverageRatingViewState extends State<AverageRatingView> {
  final DiaryController _diaryController = DiaryController();
  late List<DiaryEntry> diaryEntries;
  Map<String, double> averageRatings = {};

  @override
  void initState() {
    super.initState();
    _calculateAverageRatings();
  }

  void _calculateAverageRatings() {
    // Retrieve all diary entries
    diaryEntries = _diaryController.getAllDiaryEntries();

    // Calculate average ratings for each month
    for (var entry in diaryEntries) {
      final dateFormat = DateFormat('yyyy-MM');
      final month = dateFormat.format(entry.date);
      if (averageRatings.containsKey(month)) {
        averageRatings[month] = (averageRatings[month]! + entry.rating) / 2.0;
      } else {
        averageRatings[month] = entry.rating.toDouble();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedMonths = averageRatings.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text('Average Star Ratings by Month'),
      ),
      body: ListView.builder(
        itemCount: sortedMonths.length,
        itemBuilder: (context, index) {
          final month = sortedMonths[index];
          final averageRating = averageRatings[month];

          final formattedMonth = DateFormat('MMMM yyyy').format(DateFormat('yyyy-MM').parse(month));

          return ListTile(
            title: Text(
              'Average Rating for $formattedMonth = ${averageRating?.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
