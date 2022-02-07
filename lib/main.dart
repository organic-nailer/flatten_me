import 'package:flatten_me/start_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flatten me!',
      theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.shareTechMonoTextTheme()),
      home: const StartPage(),
    );
  }
}
