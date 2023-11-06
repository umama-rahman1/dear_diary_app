import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'package:dear_diary_app/view/welcome_page_view.dart';

class DiaryLoginView extends StatelessWidget {
  const DiaryLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to Dear Diary App, please sign in!')
                    : const Text('Welcome to Dear Diary App, please sign up!'),
              );
            },
          );
        }
        return const WelcomePageView();
      },
    );
  }
}
