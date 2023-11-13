import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String? id;
  final DateTime date;
  final String description;
  final int rating;
  final String? imageUrl;

  DiaryEntry(
      {this.id,
      required this.date,
      required this.description,
      required this.rating,
      this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }

  static DiaryEntry fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return DiaryEntry(
      id: doc.id,
      date: map['date'].toDate(),
      description: map['description'] ?? '',
      rating: map['rating'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
