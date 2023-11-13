import 'package:flutter/material.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';
import 'package:intl/intl.dart';
import 'diary_entry_edit_view.dart';

class DiaryLogFirebaseView extends StatefulWidget {
  const DiaryLogFirebaseView({super.key});

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogFirebaseView> {
  final DiaryEntryService _diaryEntryService = DiaryEntryService();
  late Stream<List<DiaryEntry>> diaryEntriesStream;
  String? selectedMonth;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Filter by month",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                      _refreshDiaryEntries();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DiaryEntry>>(
              stream: diaryEntriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final diaryEntries = snapshot.data!;
                return _buildEntriesListView(diaryEntries);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesListView(List<DiaryEntry> diaryEntries) {
    if (diaryEntries.isEmpty) {
      return const Center(
          child: Text(
        'No diary entries',
        style: TextStyle(
          fontSize: 24,
        ),
      ));
    }
    return ListView.builder(
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

    return GestureDetector(
      onTap: () {
        _navigateAndDisplayEdit(context, entry);
      },
      child: Card(
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
                    onPressed: () async {
                      try {
                        await _diaryEntryService.removeDiaryEntry(entry.date);
                        _refreshDiaryEntries();
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                              content: Text("Successfully deleted entry!")));
                      } catch (error) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                              SnackBar(content: Text(error.toString())));
                      }
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
              if (entry.imageUrl != '') ...[
                SizedBox(height: 8.0),
                Image.network(
                  entry.imageUrl!,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ],
            ],
          ),
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

  Future<void> _navigateAndDisplayEdit(
      BuildContext context, DiaryEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryEntryEditView(editEntry: entry),
      ),
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
      if (selectedMonth != null) {
        diaryEntriesStream = _diaryEntryService.getEntriesForMonth(
          months.indexOf(selectedMonth!) + 1,
          DateTime.now().year,
        );
      } else {
        diaryEntriesStream = _diaryEntryService.getUsersDiaryEntries();
      }
    });
  }
}
