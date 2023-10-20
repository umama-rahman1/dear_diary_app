import 'package:flutter/material.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';
import 'package:intl/intl.dart';

class DiaryLogView extends StatefulWidget {
  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  final DiaryController _diaryController = DiaryController();
  late List<DiaryEntry> diaryEntries;

  @override
  void initState() {
    super.initState();
    // Load diary entries when the view is initialized
    diaryEntries = _diaryController.getAllDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the Diary Entry View when the "+" icon is pressed.
              _navigateAndDisplaySubmission(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];
          return ListTile(
            title: Text(DateFormat('dd-MM-yyyy').format(entry.date)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description),
                Text('Rating: ${entry.rating} stars'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remove the diary entry from the database.
                _diaryController.removeDiaryEntry(entry.date);

                // Refresh the diary entries.
                _refreshDiaryEntries();
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateAndDisplaySubmission(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiaryEntryView()),
    );

    if (result != null) {
      // If a result is received, refresh the diary entries.
      _refreshDiaryEntries();

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }

  void _refreshDiaryEntries() {
    setState(() {
      diaryEntries = _diaryController.getAllDiaryEntries();
    });
  }
}
