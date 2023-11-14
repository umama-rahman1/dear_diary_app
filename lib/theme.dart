import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.amber,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.deliusTextTheme(),
);

final ThemeData appThemeDark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.grey[900],
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.deliusTextTheme(),
);
