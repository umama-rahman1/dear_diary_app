import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
// import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';

class AverageRatingView extends StatefulWidget {
  @override
  _AverageRatingViewState createState() => _AverageRatingViewState();
}

class _AverageRatingViewState extends State<AverageRatingView> {
  final DiaryEntryService _diaryEntryService = DiaryEntryService();
  late Stream<List<DiaryEntry>> diaryEntriesStream;
  Map<String, double> averageRatings = {};

  @override
  void initState() {
    super.initState();
    diaryEntriesStream = _diaryEntryService.getUsersDiaryEntries();
    _calculateAverageRatings();
  }

  void _calculateAverageRatings() {
    diaryEntriesStream.listen((List<DiaryEntry> entries) {
      // Calculate average ratings for each month
      for (var entry in entries) {
        final dateFormat = DateFormat('yyyy-MM');
        final month = dateFormat.format(entry.date);
        if (averageRatings.containsKey(month)) {
          averageRatings[month] = (averageRatings[month]! + entry.rating) / 2.0;
        } else {
          averageRatings[month] = entry.rating.toDouble();
        }
      }

      // Update the UI
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedMonths = averageRatings.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text('Average Star Ratings by Month'),
      ),
      body: ListView.builder(
        itemCount: sortedMonths.length,
        itemBuilder: (context, index) {
          final month = sortedMonths[index];
          final averageRating = averageRatings[month];

          final formattedMonth = DateFormat('MMMM yyyy')
              .format(DateFormat('yyyy-MM').parse(month));

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
