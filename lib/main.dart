import 'package:dear_diary_app/theme.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:dear_diary_app/view/auth_ui/diary_login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Dear Diary App',
    theme: appTheme,
    home: const DiaryLoginView(),
  ));
}
