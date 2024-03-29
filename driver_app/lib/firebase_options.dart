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
    apiKey: 'AIzaSyBmsDfUqIcj3E8lrFajTAHtfS3eWboY2VU',
    appId: '1:711824391524:web:9b116a25f557d9c4b40e71',
    messagingSenderId: '711824391524',
    projectId: 'doancnpmnhom4-6bc5e',
    authDomain: 'doancnpmnhom4-6bc5e.firebaseapp.com',
    databaseURL: 'https://doancnpmnhom4-6bc5e-default-rtdb.firebaseio.com',
    storageBucket: 'doancnpmnhom4-6bc5e.appspot.com',
    measurementId: 'G-CKN2M9QRKR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9y0Pu8TFu7mPZ02Ap1Eem4jQnQ9v9woQ',
    appId: '1:711824391524:android:3b7c102f2f736edbb40e71',
    messagingSenderId: '711824391524',
    projectId: 'doancnpmnhom4-6bc5e',
    databaseURL: 'https://doancnpmnhom4-6bc5e-default-rtdb.firebaseio.com',
    storageBucket: 'doancnpmnhom4-6bc5e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCh58FOb5dvHOd8w95Ll2QEheeEJmvMc_w',
    appId: '1:711824391524:ios:98a3d36066b16336b40e71',
    messagingSenderId: '711824391524',
    projectId: 'doancnpmnhom4-6bc5e',
    databaseURL: 'https://doancnpmnhom4-6bc5e-default-rtdb.firebaseio.com',
    storageBucket: 'doancnpmnhom4-6bc5e.appspot.com',
    androidClientId: '711824391524-gl9rnab2cjktb3oiunlh810d3l7eg179.apps.googleusercontent.com',
    iosClientId: '711824391524-tii48c4ssqv321kibqeq5t7bfk7s7vag.apps.googleusercontent.com',
    iosBundleId: 'com.example.driverApp',
  );
}
