import 'package:flutter/material.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();

class DiaryEntryView extends StatefulWidget {
  @override
  _DiaryEntryViewState createState() => _DiaryEntryViewState();
}

class _DiaryEntryViewState extends State<DiaryEntryView> {
  final DiaryEntryService _diaryEntryService = DiaryEntryService();
  DateTime selectedDate = DateTime.now();
  int selectedRating = 5;
  final TextEditingController diaryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Diary Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: diaryTextController,
              decoration: const InputDecoration(
                  labelText: 'Diary Text (140 characters or less)'),
              maxLength: 140,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Select Date:',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(now.year, now.month, now.day),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text('Choose Date',
                      style: TextStyle(
                        fontSize: 17,
                      )),
                ),
                Text(DateFormat('dd-MM-yyyy').format(selectedDate.toLocal()),
                    style: TextStyle(
                      fontSize: 17,
                    )),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Rating: ',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                DropdownButton<int>(
                  value: selectedRating,
                  items: List.generate(5, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString(),
                          style: TextStyle(
                            fontSize: 17,
                          )),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final entry = DiaryEntry(
                  date: selectedDate,
                  description: diaryTextController.text,
                  rating: selectedRating,
                );
                try {
                  await _diaryEntryService.addDiaryEntry(entry);
                  Navigator.pop(
                    context,
                    'Entry Saved!',
                  ); // Return to the Diary Log View after saving.
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Save Entry'),
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
