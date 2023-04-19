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
    apiKey: 'AIzaSyAk1XvudFS302cnbhPpnIka94st5nA23ZE',
    appId: '1:969971486820:web:40cc0abf19a909cc470f71',
    messagingSenderId: '969971486820',
    projectId: 'halaqa-89b43',
    authDomain: 'halaqa-89b43.firebaseapp.com',
    storageBucket: 'halaqa-89b43.appspot.com',
    measurementId: 'G-PCYTHJF1SD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4nBdCBA88ooTsLKbFHBCIOzdlkKzdTqM',
    appId: '1:969971486820:android:6729a20b1b9d518a470f71',
    messagingSenderId: '969971486820',
    projectId: 'halaqa-89b43',
    storageBucket: 'halaqa-89b43.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYzz0i3gEzzWWeJvm4UwQLaoQeu8rMXW0',
    appId: '1:969971486820:ios:240d162ce9c7d405470f71',
    messagingSenderId: '969971486820',
    projectId: 'halaqa-89b43',
    storageBucket: 'halaqa-89b43.appspot.com',
    iosClientId:
        '969971486820-kffbt46nm0k0or5t0jvp4gd96q5f44o1.apps.googleusercontent.com',
    iosBundleId: 'com.example.halaqaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYzz0i3gEzzWWeJvm4UwQLaoQeu8rMXW0',
    appId: '1:969971486820:ios:240d162ce9c7d405470f71',
    messagingSenderId: '969971486820',
    projectId: 'halaqa-89b43',
    storageBucket: 'halaqa-89b43.appspot.com',
    iosClientId:
        '969971486820-kffbt46nm0k0or5t0jvp4gd96q5f44o1.apps.googleusercontent.com',
    iosBundleId: 'com.example.halaqaApp',
  );
}
