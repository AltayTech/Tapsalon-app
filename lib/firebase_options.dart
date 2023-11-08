// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBSk-L4tB-5PgfTs2NSS83HhNI4F0XZtGc',
    appId: '1:524569387811:web:1d5877c568bb4000fb6296',
    messagingSenderId: '524569387811',
    projectId: 'tapsalon-app',
    authDomain: 'tapsalon-app.firebaseapp.com',
    storageBucket: 'tapsalon-app.appspot.com',
    measurementId: 'G-9LS39CX17V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDX64i383FezRyX8C6v6UnzL14DPpl-Miw',
    appId: '1:524569387811:android:36dd64927399904afb6296',
    messagingSenderId: '524569387811',
    projectId: 'tapsalon-app',
    storageBucket: 'tapsalon-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4rR3OVFmhIGinld6iv5DIWCo-qLwOUG8',
    appId: '1:524569387811:ios:283da2fc83656ec7fb6296',
    messagingSenderId: '524569387811',
    projectId: 'tapsalon-app',
    storageBucket: 'tapsalon-app.appspot.com',
    iosBundleId: 'ir.altay.tapsalon',
  );
}