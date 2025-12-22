import 'package:flutter/material.dart';

class AppConstants {
  // Environment URLs
  static const String chantsDevUrl =
      'https://raw.githubusercontent.com/yourusername/spiritual-chanting-data/main/chants.dev.json';
  
  static const String chantsProdUrl =
      'https://raw.githubusercontent.com/yourusername/spiritual-chanting-data/main/chants.prod.json';

  // Cache settings
  static const String chantsCacheFileName = 'chants_cache.json';

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 15);

  // App name & version (useful later)
  static const String appName = 'Spiritual Chanting';
  static const String appVersion = '1.0.0';

  // Add more later: API keys, feature flags, etc.
}

class AppColors {
  static const primary = Color(0xFF5E42A6);
  static const background = Color(0xFF1E0B3C);
  static const accent = Colors.amber;
  // Add more as needed
}