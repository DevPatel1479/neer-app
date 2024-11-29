import 'package:flutter/material.dart';
import 'package:neer/first_home_screen.dart';
import 'package:neer/instruction_screen.dart';
import 'package:neer/location_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class HomePage extends StatelessWidget {
  final String? comingByWhichStep;
  HomePage({this.comingByWhichStep});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(S.of(context).app_title),
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Clears the navigation stack and navigates to InstructionScreen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FirstHomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            SizedBox(width: 10), // Add some spacing if needed
            Text(
              S.of(context).app_title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background LinearLayout
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Adjust padding
              child: Column(
                children: [
                  SizedBox(height: 16), // Space at the top
                  Text(
                    S.of(context).instructions_text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF050505),
                    ),
                    textAlign: TextAlign
                        .justify, // Justify text for better readability
                  ),
                  SizedBox(height: 60), // Space for bottom button
                ],
              ),
            ),
          ),
          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 55,
              color: Color(0xFF4facfc),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button click
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LocationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF37A6F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        S.of(context).button_text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
