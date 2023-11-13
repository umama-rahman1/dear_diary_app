import 'package:flutter/material.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary_app/utils/utils.dart';

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
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String? imageLink;

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
            _buildDatePicker(),
            const SizedBox(height: 16.0),
            _buildRatingDropdown(),
            _buildImagePickerButton(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  imageLink =
                      await _diaryEntryService.uploadImageToFirebase(_image);
                } catch (e) {
                  showSnackBar(context, e.toString());
                  return;
                }
                await _saveDiaryEntry(context);
              },
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDiaryEntry(BuildContext context) async {
    // If imageLink is null, assign an empty string
    imageLink ??= '';

    final entry = DiaryEntry(
      date: selectedDate,
      description: diaryTextController.text,
      rating: selectedRating,
      imageUrl: imageLink,
    );

    try {
      await _diaryEntryService.addDiaryEntry(entry);
      Navigator.pop(
        context,
        'Entry Saved!',
      ); // Return to the Diary Log View after saving.
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Widget _buildDatePicker() {
    return Row(
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
            style: const TextStyle(
              fontSize: 17,
            )),
      ],
    );
  }

  Widget _buildRatingDropdown() {
    return Row(
      children: [
        const Text('Rating: ', style: TextStyle(fontSize: 20)),
        DropdownButton<int>(
          value: selectedRating,
          items: List.generate(5, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                (index + 1).toString(),
                style: TextStyle(fontSize: 17),
              ),
            );
          }),
          onChanged: (value) {
            setState(() {
              selectedRating = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildImagePickerButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //make this button galleryicon
          ElevatedButton(
            onPressed: () => _pickImageFromGallery(),
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: () => _pickImageFromCamera(),
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  // Image picker methods
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    diaryTextController.dispose();
    super.dispose();
  }
}
