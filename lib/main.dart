import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'view/diary_log_view.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DiaryEntryAdapter());

  Box box = await Hive.openBox<DiaryEntry>('diary_entries');

  runApp(MaterialApp(
    title: 'Dear Diary App',
    home: DiaryLogView(),
  ));
}
