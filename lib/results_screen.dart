import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
// import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ResultsScreen extends StatefulWidget {
  final double triangleValue;
  final double xValue;
  final double yValue;
  final double angleValue;
  final double correctedAngle;
  final XFile capturedImage;

  ResultsScreen({
    required this.triangleValue,
    required this.xValue,
    required this.yValue,
    required this.angleValue,
    required this.correctedAngle,
    required this.capturedImage,
  });

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = false; // State to control the loading indicator
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('observation_data');
  }

  Future<void> _saveData() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Fetch the user's email from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('user_email');
      String? waterBody = prefs.getString("water_body");
      double latitude = prefs.getDouble('latitude')!;
      double longitude = prefs.getDouble('longitude')!;
      // Fetch the current location
      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      // double latitude = position.latitude;
      // double longitude = position.longitude;

      // Format the current date and time
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      // Upload the image to Firebase Storage
      String filePath =
          'images/${widget.capturedImage.name}'; // Define the path for the image
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask =
          storageRef.putFile(File(widget.capturedImage.path));
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Create the data to save in observation_data
      Map<String, dynamic> observationData = {
        'user_email': userEmail,
        'water_body': waterBody,
        'date': formattedDate,
        'time': formattedTime,
        'latitude': latitude,
        'longitude': longitude,
        'triangleValue': widget.triangleValue,
        'xValue': widget.xValue,
        'yValue': widget.yValue,
        'angleValue': widget.angleValue,
        'correctedAngle': widget.correctedAngle,
      };

      // Save data to Firebase Realtime Database
      await _databaseReference.push().set(observationData);

      // Create a new collection called fui_water_image
      Map<String, dynamic> waterImageData = {
        'user_email': userEmail,
        'date': formattedDate,
        'time': formattedTime,
        'latitude': latitude,
        'longitude': longitude,
        'image_url': downloadUrl,
        'water_body': waterBody
      };
      await FirebaseDatabase.instance
          .ref()
          .child('fui_water_image')
          .push()
          .set(waterImageData);

      // Show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data saved successfully!')));
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save data: $e')));
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });

      // Pop three screens
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Results',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                        'Triangle Value: ${widget.triangleValue.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 18)),
                    Text('X Value: ${widget.xValue.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 18)),
                    Text('Y Value: ${widget.yValue.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 18)),
                    Text('Angle Value: ${widget.angleValue.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 18)),
                    Text(
                        'Corrected Angle: ${widget.correctedAngle.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _saveData, // Disable button while loading
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
