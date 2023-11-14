import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.amber,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.deliusTextTheme(),
);

final ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: Colors.blue,
  hintColor: Colors.blueAccent,
  scaffoldBackgroundColor: Colors.grey[900],
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.deliusTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);
