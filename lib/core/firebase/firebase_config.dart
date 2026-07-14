import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portfolio/core/config/env.dart';

/// Initializes Firebase from `.env` values and exposes Analytics.
abstract final class FirebaseConfig {
  static FirebaseAnalytics? analytics;

  static FirebaseOptions get options => FirebaseOptions(
        apiKey: Env.firebaseApiKey,
        authDomain: Env.firebaseAuthDomain,
        projectId: Env.firebaseProjectId,
        storageBucket: Env.firebaseStorageBucket,
        messagingSenderId: Env.firebaseMessagingSenderId,
        appId: Env.firebaseAppId,
        measurementId: Env.firebaseMeasurementId,
      );

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: options);
    analytics = FirebaseAnalytics.instance;
  }
}
