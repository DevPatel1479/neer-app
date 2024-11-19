import 'package:flutter/material.dart';
import 'package:neer/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Firebase configuration options
  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey:
        'API', // Replace with your API key
    appId:
        'APPID', // Replace with your App ID
    messagingSenderId: 'MESSAGINGS_SENDER_ID', // Replace with your Messaging Sender ID
    projectId: 'PROJECT_NAME', // Replace with your Project ID
    storageBucket: 'STORAGE_BUCKET_URL', // Replace with your Storage Bucket
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: firebaseOptions); // Initialize Firebase with options
  runApp(MaterialApp(
    home: 
    
    SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
