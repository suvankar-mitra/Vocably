import 'package:flutter/material.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/landing_page.dart';

void main() {
  runApp(const VocablyApp());
}

class VocablyApp extends StatelessWidget {
  const VocablyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocably',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const LandingPage(),
    );
  }
}
