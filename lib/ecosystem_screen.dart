import 'package:flutter/material.dart';
import 'package:neer/user_manage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcosystemScreen extends StatelessWidget {
  void _onImageTap(String ecosystem) {
    print('Selected Ecosystem: $ecosystem');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF4facfc),
      body: SafeArea(
        // Wrap the body with SafeArea to prevent overlapping with system bars
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4facfc), Color(0xFF37A6F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: screenHeight * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Please Select the Ecosystem',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Ecosystem selection with Flexible and ListView to prevent overflow
              Flexible(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  children: [
                    // First Item
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setString("water_body", 'Lake');

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserManage()));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/lake.jpg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                          Text(
                            'Lake',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Add spacing

                    // Second Item
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setString("water_body", 'Reservoir');

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserManage()));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/reservoir.jpg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                          Text(
                            'Reservoir',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Add spacing

                    // Third Item
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString("water_body", "Wet Land");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserManage()));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/wet.jpg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                          Text(
                            'Wet Land',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Add spacing

                    // Fourth Item
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString("water_body", "River/Stream");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserManage()));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/rr.jpeg',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.2,
                          ),
                          Text(
                            'River/Stream',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Footer message
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: Text(
                  'Please Select One WaterBody',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
