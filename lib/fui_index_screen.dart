import 'package:flutter/material.dart';
import 'package:neer/camera_for_fui.dart';
import 'generated/l10n.dart';

class FUIIndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FACFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          S.of(context).appBarTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFEBF4FA), // Background color similar to #EBF4FA
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space between elements
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Spacing from AppBar

                  // Main Content
                  Text(
                    S.of(context).instruction1,
                    style: TextStyle(
                      fontSize: 20, // Adjusted font size
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30), // Spacing

                  // Second Instruction Text
                  Text(
                    S.of(context).instruction2,
                    style: TextStyle(
                      fontSize: 20, // Adjusted font size
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30), // Additional spacing
                ],
              ),
            ),

            // Bottom LinearLayout (Horizontal)
            Container(
              width: double.infinity,
              height: 60,
              color: const Color(0xFF4FACFC),
              child: ElevatedButton(
                onPressed: () {
                  // Handle the button click
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CameraForFui()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF37A6F1), // Button color
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Adjusted padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_forward,
                        color: Colors.black), // Button icon
                    const SizedBox(width: 8), // Spacing
                    Text(
                      S.of(context).buttonText,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
