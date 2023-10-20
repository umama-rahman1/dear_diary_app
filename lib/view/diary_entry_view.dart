import 'package:flutter/material.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';

class DiaryEntryView extends StatefulWidget {
  @override
  _DiaryEntryViewState createState() => _DiaryEntryViewState();
}

class _DiaryEntryViewState extends State<DiaryEntryView> {
  final DiaryController _diaryController = DiaryController();
  DateTime selectedDate = DateTime.now();
  int selectedRating = 5;
  final TextEditingController diaryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Diary Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: diaryTextController,
              decoration: InputDecoration(
                  labelText: 'Diary Text (140 characters or less)'),
              maxLength: 140,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Select Date:'),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Choose Date'),
                ),
                Text(selectedDate.toLocal().toString()),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Rating: '),
                DropdownButton<int>(
                  value: selectedRating,
                  items: List.generate(5, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedRating = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final entry = DiaryEntry(
                  date: selectedDate,
                  description: diaryTextController.text,
                  rating: selectedRating,
                );
                // Save the diary entry using the controller.
                _diaryController.addDiaryEntry(entry);
                Navigator.pop(
                    context); // Return to the Diary Log View after saving.
              },
              child: Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    diaryTextController.dispose();
    super.dispose();
  }
}
