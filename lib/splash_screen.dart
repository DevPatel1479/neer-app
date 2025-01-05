import 'package:flutter/material.dart';
import 'package:neer/instruction_screen.dart';
import 'dart:async';

// import 'package:neer/instruction_screen.dart';
import 'package:neer/language_selection_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Initial opacity is 0 (invisible)
  String? hasUserSelectedLang;

  @override
  void initState() {
    super.initState();
    checkUserSelectedLanguage();
    // Trigger the fade-in after a short delay
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Change opacity to 1.0 (fully visible)
      });
    });

    Timer(Duration(seconds: 3), () {
      if (hasUserSelectedLang != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InstructionScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
        );
      }
    });
  }

  void checkUserSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasUserSelectedLang = prefs.getString("appLanguage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Adding the background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/mm.png'), // Replace with your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          // Centering content vertically and horizontally
          child: AnimatedOpacity(
            opacity: _opacity, // Opacity controls fade-in effect
            duration: Duration(seconds: 2), // Duration of the fade-in
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image equivalent of the ImageView in XML
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/bg.png'), // Replace with your icon image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Add spacing between the image and text
                // Text equivalent of the TextView in XML
                Text(
                  'NEER',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
