import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';

/// A service class that provides methods to perform CRUD operations
/// on user's cars stored in Firestore.
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
    return await diaryEntriesCollection.add(entry.toMap());
  }

  /// Removes a diary entry from Firestore.
  Future<void> removeDiaryEntry(String id) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to remove a diary entry.');
    }
    return await diaryEntriesCollection.doc(id).delete();
  }

  /// Updates a diary entry in Firestore.
  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('You must be logged in to update a diary entry.');
    }
    return await diaryEntriesCollection.doc(entry.id).update(entry.toMap());
  }

  // Retrieves a stream of a list of 'DiaryEntry' objects for the current user.
  Stream<List<DiaryEntry>> getUsersDiaryEntries() {
    if (user == null) {
      throw Exception('You must be logged in to view diary entries.');
    }
    return diaryEntriesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => DiaryEntry.fromMap(doc)).toList());
  }

  /// Returns a stream of a list of diary entries for the current user for the given month.
  Stream<List<DiaryEntry>> getEntriesForMonth(int month, int year) {
    if (user == null) {
      throw Exception('You must be logged in to view diary entries.');
    }

    // Get the first and last timestamps of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth =
        DateTime(year, month + 1, 1).subtract(Duration(days: 1));

    return diaryEntriesCollection
        .where('timestamp',
            isGreaterThanOrEqualTo: firstDayOfMonth,
            isLessThanOrEqualTo: lastDayOfMonth)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => DiaryEntry.fromMap(doc)).toList());
  }
}