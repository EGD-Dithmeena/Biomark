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
    apiKey: 'AIzaSyBsxoyFxQK6pldtIyZPEx7SXk1JeUJ5xrc',
    appId: '1:263499307342:web:c58f16ec8a646cdc8ea61f',
    messagingSenderId: '263499307342',
    projectId: 'biomark-d8dc9',
    authDomain: 'biomark-d8dc9.firebaseapp.com',
    storageBucket: 'biomark-d8dc9.appspot.com',
    measurementId: 'G-N0C676D8EX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG_83a42ymGvyyi37RT3AoYgoeOm5xF3A',
    appId: '1:263499307342:android:007a2b7462f281a28ea61f',
    messagingSenderId: '263499307342',
    projectId: 'biomark-d8dc9',
    storageBucket: 'biomark-d8dc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuIy8xd_K_jTt3FcnXaHG3qVPqPmovQN0',
    appId: '1:263499307342:ios:9a1d87b63d5591c68ea61f',
    messagingSenderId: '263499307342',
    projectId: 'biomark-d8dc9',
    storageBucket: 'biomark-d8dc9.appspot.com',
    iosBundleId: 'com.example.biomark',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuIy8xd_K_jTt3FcnXaHG3qVPqPmovQN0',
    appId: '1:263499307342:ios:9a1d87b63d5591c68ea61f',
    messagingSenderId: '263499307342',
    projectId: 'biomark-d8dc9',
    storageBucket: 'biomark-d8dc9.appspot.com',
    iosBundleId: 'com.example.biomark',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsxoyFxQK6pldtIyZPEx7SXk1JeUJ5xrc',
    appId: '1:263499307342:web:5435b537e97afc488ea61f',
    messagingSenderId: '263499307342',
    projectId: 'biomark-d8dc9',
    authDomain: 'biomark-d8dc9.firebaseapp.com',
    storageBucket: 'biomark-d8dc9.appspot.com',
    measurementId: 'G-WGFE6ZPM5D',
  );
}
