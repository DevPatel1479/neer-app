import 'package:flutter/material.dart';
import 'package:neer/results_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'generated/l10n.dart';

class ColorSelectionPage extends StatefulWidget {
  final XFile? capturedImage;
  final double triangleValue;
  final double xValue;
  final double yValue;
  final double angleValue;
  final double correctedAngle;

  ColorSelectionPage({
    required this.capturedImage,
    required this.triangleValue,
    required this.xValue,
    required this.yValue,
    required this.angleValue,
    required this.correctedAngle,
  });

  @override
  _ColorSelectionPageState createState() => _ColorSelectionPageState();
}

class _ColorSelectionPageState extends State<ColorSelectionPage> {
  // Define a list of colors based on the uploaded image gradient
  final List<Color> colorOptions = [
    Color(0xFF0000FF), // Blue (Excellent)
    Color(0xFF00BFFF), // Deep Sky Blue (Good)
    Color(0xFF7FFF00), // Chartreuse (Fair)
    Color(0xFF32CD32), // Lime Green (Moderate)
    Color(0xFFFFD700), // Golden Yellow (Slightly Polluted)
    Color(0xFFFFA500), // Orange (Unacceptable)
    Color(0xFFFF4500), // Orange Red (Very Poor)
    Color(0xFFFF0000), // Red (Critical)
    Color(0xFF8B0000), // Dark Red (Extremely Poor)
    Color(0xFF8B008B), // Dark Magenta (Hazardous)
    Color(0xFF9400D3), // Dark Violet (Dangerous)
    Color(0xFF4B0082), // Indigo (Very Dangerous)
    Color(0xFF7B68EE), // Medium Slate Blue (Severe)
    Color(0xFF00008B), // Dark Blue (Extremely Critical)
    Color(0xFF000000), // Black (Not Usable)
    Color(0xFF808080), // Gray (Unknown)
    Color(0xFF00FF00), // Lime (Experimental)
    Color(0xFF00FFFF), // Cyan (Alert)
    Color(0xFFFF69B4), // Hot Pink (Warning)
    Color(0xFFB22222), // Firebrick (Critical Alert)
    Color(0xFFDAA520), // Golden Rod (Alert Level)];
  ];
  // Keep track of selected colors
  List<bool> selectedColors;

  _ColorSelectionPageState()
      : selectedColors = List.generate(21, (index) => false);

  void submitColors() {
    List<int> selectedIndices = [];
    for (int i = 0; i < selectedColors.length; i++) {
      if (selectedColors[i]) {
        selectedIndices.add(i + 1); // To keep colors starting from 1
      }
    }

    // Validate the selection
    if (selectedIndices.length != 1) {
      // Show a dialog if the selection is not exactly three
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).invalidSelectionTitle),
            content: Text(S.of(context).invalidSelectionMessage),
            actions: [
              TextButton(
                child: Text(S.of(context).ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Proceed with the selected colors if valid
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResultsScreen(
                triangleValue: widget.triangleValue,
                xValue: widget.xValue,
                yValue: widget.yValue,
                angleValue: widget.angleValue,
                correctedAngle: widget.correctedAngle,
                capturedImage: widget.capturedImage!,
              )));
      // You can navigate to another screen or do something else here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectWaterColour),
        backgroundColor: Colors.blue,
        leading: IconButton(
          // Back button
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Linear Gradient background
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                S.of(context).imageCaptured,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              widget.capturedImage != null
                  ? Image.file(
                      File(widget.capturedImage!.path),
                      width: 150, // Thumbnail size
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              SizedBox(height: 20),
              Text(
                S.of(context).selectWaterColour,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Replacing Expanded with Flexible
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Make it responsive
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:
                        1.5, // Increase this value to decrease box height
                  ),
                  itemCount: selectedColors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle the selection state only if the current selection is valid
                          if (selectedColors[index]) {
                            selectedColors[index] = false; // Deselect
                          } else {
                            // Count how many boxes are currently selected
                            int selectedCount = selectedColors
                                .where((selected) => selected)
                                .length;
                            if (selectedCount < 1) {
                              selectedColors[index] =
                                  true; // Select only if less than 1 selected
                            } else {
                              // Optionally show a message if trying to select more than 1
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).snackBarMessage),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(
                            2), // Decreased margin to make the boxes smaller
                        decoration: BoxDecoration(
                          color: selectedColors[index]
                              ? colorOptions[index]
                              : colorOptions[index]?.withOpacity(0.5),
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              BorderRadius.circular(8), // Added border radius
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: colorOptions[index],
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              if (selectedColors[
                                  index]) // Show tick mark if selected
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30, // Decreased size of the tick mark
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: submitColors,
                  child: Text(S.of(context).submit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: EdgeInsets.symmetric(
                        horizontal: 80, vertical: 20), // Increased size
                    textStyle: TextStyle(fontSize: 22), // Increased font size
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Added border radius
                    ),
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
