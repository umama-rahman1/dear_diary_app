import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:hive/hive.dart';

class DiaryController {
  final String _boxName = 'diary_entries';

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    final box = await Hive.openBox<DiaryEntry>(_boxName);

    if (box.containsKey(entry.date.toString())) {
      throw Exception('Diary entry for this already exists.');
    }
    await box.put(entry.date.toString(), entry);
  }

  Future<void> removeDiaryEntry(DateTime date) async {
    final box = await Hive.openBox<DiaryEntry>(_boxName);

    if (box.containsKey(date.toString())) {
      await box.delete(date.toString());
    } else {
      throw Exception('Diary entry for this date does not exist.');
    }
  }

  List<DiaryEntry> getAllDiaryEntries() {
    final box = Hive.box<DiaryEntry>(_boxName);
    return box.values.toList();
  }

  List<DiaryEntry> getEntriesForMonth(int month, int year) {
    final box = Hive.box<DiaryEntry>(_boxName);
    return box.values
        .where((element) =>
            element.date.month == month && element.date.year == year)
        .toList();
  }
}
