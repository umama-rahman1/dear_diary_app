import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';
import 'package:fl_chart/fl_chart.dart';

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
      body: Column(
        children: [
          SizedBox(height: 35.0), // Add desired height above the chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  barGroups: sortedMonths.map((month) {
                    final averageRating = averageRatings[month] ?? 0.0;
                    return BarChartGroupData(
                      x: sortedMonths.indexOf(month),
                      barRods: [
                        BarChartRodData(
                          y: averageRating,
                          colors: [Colors.blue],
                          width: 20.0,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        if (value.toInt() < 0 ||
                            value.toInt() >= sortedMonths.length) {
                          return '';
                        }
                        return sortedMonths[value.toInt()];
                      },
                    ),
                    topTitles: SideTitles(showTitles: false), // Hide top titles
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
