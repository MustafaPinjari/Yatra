import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Base URL for YATRA FastAPI backend.
  /// Defaults to http://127.0.0.1:8000 on Web, Desktop, and iOS simulator.
  /// When on Android Emulator, http://10.0.2.2:8000 routes to the host machine.
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('YATRA_API_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 8);
}
