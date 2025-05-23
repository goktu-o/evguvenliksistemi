// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCVuqUIHhkxm_QgpG3ky9DX8SaZLMpHj6c',
    appId: '1:1098907019326:web:910dfa87aa01a34b68c96f',
    messagingSenderId: '1098907019326',
    projectId: 'mezuniyet-projesi-iot-firebase',
    authDomain: 'mezuniyet-projesi-iot-firebase.firebaseapp.com',
    databaseURL: 'https://mezuniyet-projesi-iot-firebase-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mezuniyet-projesi-iot-firebase.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGhFANaVeKumUVmrvNLaRnkimtfjYBgpc',
    appId: '1:1098907019326:android:aad4a38e131bcaff68c96f',
    messagingSenderId: '1098907019326',
    projectId: 'mezuniyet-projesi-iot-firebase',
    databaseURL: 'https://mezuniyet-projesi-iot-firebase-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'mezuniyet-projesi-iot-firebase.firebasestorage.app',
  );

}