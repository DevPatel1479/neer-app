import 'package:flutter/material.dart';
import 'package:neer/instruction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreen createState() => _LanguageSelectionScreen();
}

class _LanguageSelectionScreen extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Language",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.withOpacity(0.6),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.6), // Soft Blue
              Colors.cyan.withOpacity(0.5), // Cyan for a watery feel
              Color.fromARGB(255, 124, 227, 127)
                  .withOpacity(0.4), // Light Green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 0.6, 0.9],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              LanguageButton(
                language: "English",
                onPressed: () async {
                  // Add your language selection logic here

                  print("English selected");
                  await _setLanguageAndNavigate(context, Locale("en"));
                },
              ),
              SizedBox(height: 20),
              LanguageButton(
                language: "Hindi",
                onPressed: () async {
                  // Add your language selection logic here
                  print("Hindi selected");
                  await _setLanguageAndNavigate(context, Locale("hi"));
                },
              ),
              SizedBox(height: 20),
              LanguageButton(
                language: "Gujarati",
                onPressed: () async {
                  // Add your language selection logic here
                  print("Gujarati selected");
                  await _setLanguageAndNavigate(context, Locale("gu"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setLanguageAndNavigate(
      BuildContext context, Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("appLanguage", locale.languageCode);

    NeerApp.setLocale(context, locale);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => InstructionScreen()),
      (Route<dynamic> route) =>
          false, // This condition removes all the previous routes
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String language;
  final VoidCallback onPressed;

  const LanguageButton({required this.language, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // To make the button full-width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: 18), // Same padding for all buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              Colors.white.withOpacity(0.8), // Slightly transparent background
          side: BorderSide(
            color: Colors.white.withOpacity(0.8),
            width: 2,
          ),
        ),
        child: Text(
          language,
          style: TextStyle(
            fontSize: 22, // Larger text for better readability
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
