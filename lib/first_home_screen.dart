import 'package:flutter/material.dart';
import 'package:neer/help.dart';
import 'package:neer/home_screen.dart';
import 'package:neer/instruction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neer/sign_up_screen.dart';
import 'generated/l10n.dart';

class FirstHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Full screen background
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(
                        0xFF00BFFF), // Use the colors from your gradient background
                    Color.fromARGB(255, 63, 114, 159),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.all(3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon with background
                  Container(
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.4, // Making it responsive
                    margin: EdgeInsets.only(bottom: 29),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/bg.png',
                        fit: BoxFit.contain,
                      ), // Placeholder for the icon
                    ),
                  ),
                  // Title text
                  Text(
                    S.of(context).neer,
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color #ffff
                    ),
                  ),
                  SizedBox(height: 29),
                  // Welcome button
                  SizedBox(
                    width: screenWidth * 0.6, // Responsive width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF16AE1C), // Background color #16AE1C
                        minimumSize:
                            Size(screenWidth * 0.6, 60), // Dynamic height
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? email = prefs.getString("user_email");
                        if (email != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignInPage()));
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 30), // Adjust size as needed
                          SizedBox(width: 10),
                          Text(S.of(context).welcome),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Help button
                  SizedBox(
                    width: screenWidth * 0.6, // Responsive width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF16AE1C), // Background color #16AE1C
                        minimumSize:
                            Size(screenWidth * 0.6, 60), // Dynamic height
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Help()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.help_outline,
                              size: 30), // Adjust size as needed
                          SizedBox(width: 10),
                          Text(S.of(context).help),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Social icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          'assets/bar.png',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Flexible(
                        child: Image.asset(
                          'assets/dee.png',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Flexible(
                        child: Image.asset(
                          'assets/dst.png',
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Description text
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Text(
                      S.of(context).developed_part_of_project_neer,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color #000000 (black)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
