import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions não configurado para web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbprprLH97bWZ8d3Iy7boBTP99Od79trA',
    appId: '1:935520052909:android:b398b7d7534a503c3b4824',
    messagingSenderId: '935520052909',
    projectId: 'bible-reader-app-c16bb',
    storageBucket: 'bible-reader-app-c16bb.firebasestorage.app',
  );
}