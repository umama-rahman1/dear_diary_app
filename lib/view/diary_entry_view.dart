import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

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
                final entry = DiaryEntry(
                  date: selectedDate,
                  description: diaryTextController.text,
                  rating: selectedRating,
                );
                try {
                  await _uploadImageToFirebase();
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

  // widget to build button for uploading image from gallery and camera
  Widget _buildImagePickerButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _pickImageFromGallery(),
          child: const Text('Pick Image from Gallery'),
        ),
        const SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () => _pickImageFromCamera(),
          child: const Text('Pick Image from Camera'),
        ),
      ],
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

  Future<void> _uploadImageToFirebase() async {
    // Check if the image is null (not selected). If so, return immediately.
    if (_image == null) return;
    // Retrieve the current logged-in user from Firebase Authentication.
    final currentUser = FirebaseAuth.instance.currentUser;
    // If there's no logged-in user, return immediately.
    if (currentUser == null) return;
    // Define a reference in Firebase Storage where we want to upload the image.
    // We are organizing images in a folder named by the user's UID, and the image is named af
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/${currentUser.uid}/${_image!.name}');
    try {
      // Start the upload process to Firebase Storage and wait for it to finish.
      final uploadTask = await firebaseStorageRef.putFile(File(_image!.path));
      // Check if the upload was successful.
      if (uploadTask.state == TaskState.success) {
        // If successful, get the download URL of the uploaded image and print it.
        final downloadURL = await firebaseStorageRef.getDownloadURL();
        print("Uploaded to: $downloadURL");
      }
    } catch (e) {
      // Handle any errors that might occur during the upload process.
      // Print the error message.
      print("Failed to upload image: $e");
    }
  }

  @override
  void dispose() {
    diaryTextController.dispose();
    super.dispose();
  }
}
