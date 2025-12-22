import 'package:flutter/material.dart';
import 'package:spiritual_chanting/pages/home_page.dart';
import 'package:spiritual_chanting/core/constants.dart';

void main() {
  runApp(const SpiritualChantingApp());
}

class SpiritualChantingApp extends StatelessWidget {
  const SpiritualChantingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Chanting',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:  AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E42A6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChantingHomePage(),
    );
  }
}