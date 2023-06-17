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
        return macos;
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
    apiKey: 'AIzaSyBkR3cd6FD_LvPIwmqg-jSRW6foO1TUTlQ',
    appId: '1:80539484335:web:6d1a146ed9d8ce61b6945a',
    messagingSenderId: '80539484335',
    projectId: 'real-time-messaging-557cb',
    authDomain: 'real-time-messaging-557cb.firebaseapp.com',
    storageBucket: 'real-time-messaging-557cb.appspot.com',
    measurementId: 'G-HNMTQZW26R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM_0EMblkY-7ZWCLTSfJhrf32XcMOmAGk',
    appId: '1:80539484335:android:e9250bc2663948c8b6945a',
    messagingSenderId: '80539484335',
    projectId: 'real-time-messaging-557cb',
    storageBucket: 'real-time-messaging-557cb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBve-v4DoQYkg6BltiRpgGlAN29XWzc0QU',
    appId: '1:80539484335:ios:a8591e99fdc487efb6945a',
    messagingSenderId: '80539484335',
    projectId: 'real-time-messaging-557cb',
    storageBucket: 'real-time-messaging-557cb.appspot.com',
    iosClientId: '80539484335-lt44de0h02b2e55e0l222ak26hl6mibj.apps.googleusercontent.com',
    iosBundleId: 'com.example.realtimeMessaging',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBve-v4DoQYkg6BltiRpgGlAN29XWzc0QU',
    appId: '1:80539484335:ios:a8591e99fdc487efb6945a',
    messagingSenderId: '80539484335',
    projectId: 'real-time-messaging-557cb',
    storageBucket: 'real-time-messaging-557cb.appspot.com',
    iosClientId: '80539484335-lt44de0h02b2e55e0l222ak26hl6mibj.apps.googleusercontent.com',
    iosBundleId: 'com.example.realtimeMessaging',
  );
}
