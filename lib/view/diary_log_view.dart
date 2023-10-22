import 'package:flutter/material.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';
import 'package:intl/intl.dart';

class DiaryLogView extends StatefulWidget {
  const DiaryLogView({super.key});

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  final DiaryController _diaryController = DiaryController();
  late List<DiaryEntry> diaryEntries;

  @override
  void initState() {
    super.initState();
    _refreshDiaryEntries();
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
              _navigateAndDisplaySubmission(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];
          final dateFormat = DateFormat('MMMM yyyy');
          final currentMonth = dateFormat.format(entry.date);

          if (index == 0 ||
              currentMonth != dateFormat.format(diaryEntries[index - 1].date)) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(currentMonth,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                _buildDiaryEntryTile(entry),
                SizedBox(height: 8.0),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                _buildDiaryEntryTile(entry),
                SizedBox(height: 8.0),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDiaryEntryTile(DiaryEntry entry) {
    final starIcon = Icon(
      Icons.star,
      color: Colors.amber,
    );
    final ratingStars = Row(
      children: List.generate(entry.rating, (index) => starIcon),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('E, MMM d').format(entry.date),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ratingStars,
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _diaryController.removeDiaryEntry(entry.date);
                    _refreshDiaryEntries();
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              entry.description,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
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
      diaryEntries.sort((a, b) => b.date.compareTo(a.date));
    });
  }
}
