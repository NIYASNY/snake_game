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
    apiKey: 'AIzaSyB5fMbgPgwQGI7RzaRlBX8oJFe6RDKgRZQ',
    appId: '1:49215298774:web:fac89060a7cf9a4e093d77',
    messagingSenderId: '49215298774',
    projectId: 'gameapp-414f9',
    authDomain: 'gameapp-414f9.firebaseapp.com',
    storageBucket: 'gameapp-414f9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBN3d__xISc0PJVM8XuvFl5Oa4NKzKcv0w',
    appId: '1:49215298774:android:3749d6bf0f8c3f92093d77',
    messagingSenderId: '49215298774',
    projectId: 'gameapp-414f9',
    storageBucket: 'gameapp-414f9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnaUDx2YiwcLiMeC0EQ1hgt8Sree3OsbE',
    appId: '1:49215298774:ios:d4477a33265d4e37093d77',
    messagingSenderId: '49215298774',
    projectId: 'gameapp-414f9',
    storageBucket: 'gameapp-414f9.appspot.com',
    iosBundleId: 'com.example.flutterGameApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnaUDx2YiwcLiMeC0EQ1hgt8Sree3OsbE',
    appId: '1:49215298774:ios:ff8c95da135dfbdf093d77',
    messagingSenderId: '49215298774',
    projectId: 'gameapp-414f9',
    storageBucket: 'gameapp-414f9.appspot.com',
    iosBundleId: 'com.example.flutterGameApp.RunnerTests',
  );
}
