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
    apiKey: 'AIzaSyBjyODHEB9Uj0q0TbH3Z_NQZ9NYfIhZA4s',
    appId: '1:1071765608673:web:c831e69d6faff9d91a7fa0',
    messagingSenderId: '1071765608673',
    projectId: 'raqeeb-32feb',
    authDomain: 'raqeeb-32feb.firebaseapp.com',
    storageBucket: 'raqeeb-32feb.appspot.com',
    measurementId: 'G-H8LVF2B7Z9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYIdhGJFyLd05ssgP9kX2sNnidMhavaO0',
    appId: '1:1071765608673:android:190938a10886b74f1a7fa0',
    messagingSenderId: '1071765608673',
    projectId: 'raqeeb-32feb',
    storageBucket: 'raqeeb-32feb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBS1J932NSYPpRdy3--dv0PdIJDzUotiBs',
    appId: '1:1071765608673:ios:a20194985906fe6c1a7fa0',
    messagingSenderId: '1071765608673',
    projectId: 'raqeeb-32feb',
    storageBucket: 'raqeeb-32feb.appspot.com',
    iosClientId: '1071765608673-douba34g57n99pbdls6t253r3ilt2ns4.apps.googleusercontent.com',
    iosBundleId: 'com.example.raqeebApp4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBS1J932NSYPpRdy3--dv0PdIJDzUotiBs',
    appId: '1:1071765608673:ios:10c585b8ca9be2761a7fa0',
    messagingSenderId: '1071765608673',
    projectId: 'raqeeb-32feb',
    storageBucket: 'raqeeb-32feb.appspot.com',
    iosClientId: '1071765608673-6gpb9qpsekenbevjgregb826nqls07jb.apps.googleusercontent.com',
    iosBundleId: 'com.example.raqeebApp4.RunnerTests',
  );
}
