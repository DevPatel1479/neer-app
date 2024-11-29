// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'dart:async';
// import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Water Quality App'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // Top Row with Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildFeatureButton(
//                     context, 'Gray Card', Icons.crop_square, 'land'),
//                 _buildFeatureButton(context, 'Sky', Icons.wb_sunny, 'sky'),
//                 _buildFeatureButton(context, 'Water', Icons.opacity, 'water'),
//               ],
//             ),
//             SizedBox(height: 20),

//             // GPS and Map Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Lat: 48.155', style: TextStyle(fontSize: 16)),
//                         Text('Lon: -123.150', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text('Get GPS Fix'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: Center(
//                     child: Icon(Icons.map, size: 100, color: Colors.grey),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.data_usage), label: 'Collect Data'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.library_books), label: 'Library'),
//         ],
//       ),
//     );
//   }

//   Widget _buildFeatureButton(
//       BuildContext context, String title, IconData icon, String mode) {
//     return Column(
//       children: [
//         IconButton(
//           icon: Icon(icon, size: 50),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CameraScreen(mode: mode)),
//             );
//           },
//         ),
//         Text(title),
//       ],
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   final String mode; // 'land', 'sky', or 'water'

//   CameraScreen({required this.mode});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? controller;
//   List<CameraDescription>? cameras;
//   late StreamSubscription<AccelerometerEvent> _streamSubscription;
//   double? pitch;
//   double? roll;
//   bool _buttonEnabled = false;
//   double? _lastPitch;
//   double? _lastRoll;
//   final _stabilityThreshold = 2.0; // Degree threshold for stability

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     startListeningToSensors();
//   }

//   void initializeCamera() async {
//     cameras = await availableCameras();
//     controller = CameraController(cameras![0], ResolutionPreset.high);
//     await controller?.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void startListeningToSensors() {
//     _streamSubscription = accelerometerEvents.listen((event) {
//       setState(() {
//         pitch = _smoothValue(event.x, _lastPitch);
//         roll = _smoothValue(event.y, _lastRoll);
//         _lastPitch = pitch;
//         _lastRoll = roll;
//         _buttonEnabled = _isAllowedToTakePhoto();
//       });
//     });
//   }

//   double _smoothValue(double newValue, double? lastValue) {
//     if (lastValue == null) return newValue;
//     return (lastValue * 0.8) + (newValue * 0.2); // Simple smoothing
//   }

//   bool _isAllowedToTakePhoto() {
//     if (pitch == null || roll == null) return false;

//     double pitchDegree =
//         (pitch! * 180 / 3.14).abs(); // Convert radian to degree

//     switch (widget.mode) {
//       case 'land':
//         return pitchDegree >= 30 && pitchDegree <= 40; // Adjust for land
//       case 'sky':
//         return pitchDegree >= 70 && pitchDegree <= 90; // Adjust for sky
//       case 'water':
//         return pitchDegree >= 10 && pitchDegree <= 30; // Adjust for water
//       default:
//         return false;
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     _streamSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller == null || !controller!.value.isInitialized) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take Photo'),
//       ),
//       body: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: controller!.value.aspectRatio,
//             child: CameraPreview(controller!),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Pitch: ${(pitch ?? 0).toStringAsFixed(2)}\nRoll: ${(roll ?? 0).toStringAsFixed(2)}\nDegree: ${((pitch ?? 0) * 180 / 3.14).toStringAsFixed(2)}',
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _buttonEnabled
//                 ? () async {
//                     final image = await controller?.takePicture();
//                     if (image != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DisplayPictureScreen(imagePath: image.path),
//                         ),
//                       );
//                     }
//                   }
//                 : null,
//             child: Text('Capture'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   DisplayPictureScreen({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Preview'),
//       ),
//       body: Center(
//         child: Image.file(File(imagePath)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:neer/language_selection_screen.dart';
import 'package:neer/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Firebase configuration options
  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey:
        'AIzaSyDhJLQ1w_BuDb39HT9FDZ5Om1YkJi66Mwk', // Replace with your API key
    appId:
        '1:430115449830:android:e9e8a2ff158b79ae674427', // Replace with your App ID
    messagingSenderId: '430115449830', // Replace with your Messaging Sender ID
    projectId: 'neer-db', // Replace with your Project ID
    storageBucket: 'neer-db.appspot.com', // Replace with your Storage Bucket
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: firebaseOptions); // Initialize Firebase with options

  // runApp(MaterialApp(
  //   home: SplashScreen(),
  //   debugShowCheckedModeBanner: false,
  // ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('appLanguage');
  Locale locale = languageCode != null ? Locale(languageCode) : Locale('en');
  print("selected language is $languageCode");
  runApp(NeerApp(locale: locale));
}

class NeerApp extends StatefulWidget {
  final Locale locale;
  NeerApp({required this.locale});
  static void setLocale(BuildContext context, Locale newLocale) {
    _NeerApp? state = context.findAncestorStateOfType<_NeerApp>();
    state?.setLocale(newLocale);
  }

  @override
  _NeerApp createState() => _NeerApp();
}

class _NeerApp extends State<NeerApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: SplashScreen(),
    );
  }
}
