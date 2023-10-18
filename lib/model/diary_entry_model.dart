import 'package:hive/hive.dart';

part 'diary_entry_model.g.dart';

@HiveType(typeId: 1)
class DiaryEntryModel extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String description;

  @HiveField(2)
  int rating;

  DiaryEntryModel(
      {required this.date, required this.description, required this.rating});
}
