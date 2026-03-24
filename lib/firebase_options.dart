import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:web:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
    authDomain: 'todo-app-c176c.firebaseapp.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:android:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:ios:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:ios:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:android:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBremf3uRtSCBucox1m8qaVQR-yo2hM358',
    appId: '1:898592938249:android:64d7a7819935405ea6dbd8',
    messagingSenderId: '898592938249',
    projectId: 'todo-app-c176c',
    storageBucket: 'todo-app-c176c.firebasestorage.app',
  );
}
