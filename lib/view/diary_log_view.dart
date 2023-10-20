import 'package:flutter/material.dart';
// import diary_entry_model.dart
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';

class DiaryLogView extends StatelessWidget {
  final DiaryController _diaryController = DiaryController();

  @override
  Widget build(BuildContext context) {
    final List<DiaryEntry> diaryEntries = _diaryController.getAllDiaryEntries();

    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the Diary Entry View when the "+" icon is pressed.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiaryEntryView()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];
          return ListTile(
            title: Text(entry.date.toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description),
                Text('Rating: ${entry.rating} stars'),
              ],
            ),
          );
        },
      ),
    );
  }
}
