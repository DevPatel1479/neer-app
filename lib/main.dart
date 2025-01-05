
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
        '', // Replace with your API key
    appId:
        '', // Replace with your App ID
    messagingSenderId: '', // Replace with your Messaging Sender ID
    projectId: '', // Replace with your Project ID
    storageBucket: '', // Replace with your Storage Bucket
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
