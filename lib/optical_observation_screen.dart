import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences
// import 'package:geolocator/geolocator.dart'; // Import Geolocator for location services
import 'package:intl/intl.dart'; // Import intl for formatting date and time
import 'package:neer/local_database/database_helper.dart';

class OpticalObservationsScreen extends StatefulWidget {
  @override
  _OpticalObservationsScreenState createState() =>
      _OpticalObservationsScreenState();
}

class _OpticalObservationsScreenState extends State<OpticalObservationsScreen> {
  final TextEditingController _depthController =
      TextEditingController(); // Controller for Secchi Depth
  String? _userEmail; // Variable to store user email
  String _currentDate = ''; // Variable to store current date
  String _currentTime = ''; // Variable to store current time
  double? _latitude; // Variable to store latitude
  double? _longitude; // Variable to store longitude
  bool _isLoading = false; // Variable to control loading state

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation(); // Fetch the current location
    _fetchUserEmail(); // Fetch the user email from SharedPreferences
    _setCurrentDateTime(); // Set current date and time
  }

  // Fetch current user email from SharedPreferences
  Future<void> _fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email'); // Adjust the key as needed
    });
  }

  // Fetch the current date and time
  void _setCurrentDateTime() {
    DateTime now = DateTime.now();
    setState(() {
      _currentDate =
          DateFormat('yyyy-MM-dd').format(now); // Format current date
      _currentTime = DateFormat('HH:mm:ss').format(now); // Format current time
    });
  }

  // Fetch the current location (latitude and longitude)
  Future<void> _fetchCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _latitude = prefs.getDouble('latitude');
    _longitude = prefs.getDouble('longitude');

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   _latitude = position.latitude; // Store latitude
    //   _longitude = position.longitude; // Store longitude
    // });
    // print('Current Location: Latitude: $_latitude, Longitude: $_longitude');
  }

  Future<String?> _showTitleInputDialog() async {
    String? title;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Observation Title'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: InputDecoration(hintText: "Observation Title"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(title); // Return the entered title
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    return title;
  }

  // Method to upload data into Firebase Realtime Database
  Future<void> _uploadData() async {
    // Check if Secchi Depth is empty
    if (_depthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid Secchi Depth')),
      );
      return;
    }

    // Validate Secchi Depth
    final String depthText = _depthController.text;
    final double? depthValue = double.tryParse(depthText);

    // Check if the depthValue is null (indicating invalid input)
    if (depthValue == null || depthValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please enter a valid numeric value for Secchi Depth')),
      );
      return;
    }

    String? observationTitle = await _showTitleInputDialog();
    if (observationTitle == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter title for observation")));
      return;
    }

    // Check for location availability
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Unable to fetch location. Please ensure location services are enabled.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    // Prepare the data to be uploaded
    final Map<String, dynamic> data = {
      'secchi_depth': depthValue, // Store the validated numeric value
      'user_email': _userEmail,
      'date': _currentDate,
      'time': _currentTime,
      'latitude': _latitude,
      'longitude': _longitude,
    };

    Map<String, dynamic> observation = {
      'title': observationTitle,
      'date': _currentDate,
      'time': _currentTime,
      'latitude': _latitude,
      'longitude': _longitude,
      'turbidity': 'N/A',
      'spm': 'N/A',
      'ref_red': 0,
      'ref_green': 0,
      'ref_blue': 0,
      'secchi_depth': depthValue,
    };

    await DatabaseHelper.instance.insertObservation(observation);

    // Upload data to Firebase Realtime Database
    DatabaseReference ref = FirebaseDatabase.instance.ref('observation_data');
    await ref.push().set(data).then((_) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data uploaded successfully!'),
      ));

      // Pop two screens after successful save
      Navigator.pop(context); // Pop current screen
      Navigator.pop(context); // Pop the previous screen
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading data: $error'),
      ));
    }).whenComplete(() {
      setState(() {
        _isLoading = false; // Stop loading
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secchi Depth Observation"),
        backgroundColor: const Color(0xFF4FACFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle home button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFEBF4FA),
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image at the top
              Container(
                width: double.infinity,
                height: 500,
                child: Image.asset(
                  'assets/app.png', // Replace with your actual image asset
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),

              // Secchi Depth Input Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Secchi Depth  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _depthController, // Assign the controller
                        decoration: InputDecoration(
                          hintText: "Enter the depth in (m)",
                          filled: true,
                          fillColor: const Color(0xFFD0E8F2),
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _uploadData(); // Call the upload method
                    },
                    child: _isLoading // Check if loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E8FD5), // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
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
