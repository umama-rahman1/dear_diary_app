import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiaryEntryService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference diaryEntriesCollection;

  DiaryEntryService()
      : diaryEntriesCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('diaryEntries');

  /// Adds a new diary entry to Firestore.
  Future<DocumentReference<Object?>> addDiaryEntry(DiaryEntry entry) async {
    if (user == null) {
      throw Exception('You must be logged in to add a diary entry.');
    }

    QuerySnapshot<Object?> existingEntries =
        await diaryEntriesCollection.where('date', isEqualTo: entry.date).get();

    if (existingEntries.docs.isEmpty) {
      return await diaryEntriesCollection.add(entry.toMap());
    } else {
      throw Exception('Diary Entry for this date already exists.');
    }
  }

  /// Removes a diary entry from Firestore. removing based on date
  Future<void> removeDiaryEntry(DateTime date) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to remove a diary entry.');
    }
    return await diaryEntriesCollection
        .where('date', isEqualTo: date)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.delete();
    });
  }

  /// Updates a diary entry in Firestore.
  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to update a diary entry.');
    }

    QuerySnapshot<Object?> existingEntries =
        await diaryEntriesCollection.where('date', isEqualTo: entry.date).get();

    if (existingEntries.docs.isNotEmpty) {
      return await existingEntries.docs.first.reference.update(entry.toMap());
    } else {
      throw Exception('Diary Entry for this date does not exist.');
    }
  }

  // Retrieves a stream of a list of 'DiaryEntry' objects for the current user.
  Stream<List<DiaryEntry>> getUsersDiaryEntries() {
    if (user == null) {
      throw Exception('You must be logged in to view diary entries.');
    }

    return diaryEntriesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return DiaryEntry(
          id: doc.id,
          date: data['date'].toDate(),
          description: data['description'] ?? '',
          rating: data['rating'] ?? 0,
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    });
  }

  /// Returns a stream of a list of diary entries for the current user for the given month.
  Stream<List<DiaryEntry>> getEntriesForMonth(int month, int year) {
    if (user == null) {
      throw Exception('You must be logged in to view diary entries.');
    }

    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth =
        DateTime(year, month + 1, 1).subtract(Duration(days: 1));

    return diaryEntriesCollection
        .where('date',
            isGreaterThanOrEqualTo: firstDayOfMonth,
            isLessThanOrEqualTo: lastDayOfMonth)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return DiaryEntry(
          id: doc.id,
          date: data['date'].toDate(),
          description: data['description'] ?? '',
          rating: data['rating'] ?? 0,
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    });
  }

  Future<String?> uploadImageToFirebase(image) async {
    String? downloadURL;
    if (image == null) return null;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    // Define a reference in Firebase Storage where we want to upload the image.
    // We are organizing images in a folder named by the user's UID, and the image is named af
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('images/${currentUser.uid}/${image!.name}');
    try {
      final uploadTask = await firebaseStorageRef.putFile(File(image!.path));

      if (uploadTask.state == TaskState.success) {
        downloadURL = await firebaseStorageRef.getDownloadURL();
      }
      return downloadURL;
    } catch (e) {
      throw ("Failed to upload image: $e");
    }
  }
}
