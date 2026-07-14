import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values from the root `.env` file.
abstract final class Env {
  static String _require(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing or empty env variable: $key');
    }
    return value;
  }

  static String? _optional(String key) {
    final value = dotenv.env[key]?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  // Firebase
  static String get firebaseApiKey => _require('FIREBASE_API_KEY');
  static String get firebaseAuthDomain => _require('FIREBASE_AUTH_DOMAIN');
  static String get firebaseProjectId => _require('FIREBASE_PROJECT_ID');
  static String get firebaseStorageBucket => _require('FIREBASE_STORAGE_BUCKET');
  static String get firebaseMessagingSenderId =>
      _require('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseAppId => _require('FIREBASE_APP_ID');
  static String? get firebaseMeasurementId =>
      _optional('FIREBASE_MEASUREMENT_ID');

  // Contact Me form
  static String get contactFormAccessKey => _require('CONTACT_FORM_ACCESS_KEY');
}
