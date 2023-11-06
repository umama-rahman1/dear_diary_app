import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'view/welcome_page_view.dart';
import 'package:dear_diary_app/view/auth_ui/diary_login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(DiaryEntryAdapter());

  Box box = await Hive.openBox<DiaryEntry>('diaryEntries');

  runApp(MaterialApp(
    title: 'Dear Diary App',
    theme: appTheme,
    home: DiaryLoginView(),
  ));
}
