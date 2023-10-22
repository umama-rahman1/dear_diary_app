import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'view/diary_log_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DiaryEntryAdapter());

  Box box = await Hive.openBox<DiaryEntry>('diaryEntries');

  runApp(MaterialApp(
    title: 'Dear Diary App',
    theme: appTheme,
    home: DiaryLogView(),
  ));
}
