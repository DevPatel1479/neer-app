import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:neer/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart'; // For sha256 hashing

class PartialRegistrationScreen extends StatelessWidget {
  final String email;

  PartialRegistrationScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PartialVolunteerYourself(
        email: email,
      ),
    );
  }
}

class PartialVolunteerYourself extends StatefulWidget {
  final String email;

  PartialVolunteerYourself({required this.email});

  @override
  _VolunteerYourselfState createState() => _VolunteerYourselfState();
}

class _VolunteerYourselfState extends State<PartialVolunteerYourself> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    'fname': '',
    'lname': '',
    'email': '',
    'insti': '',
    'state': null,
    'city': null,
    'pass': '',
    'pass_conf': '',
  };
  bool isLoading = false;

  List<dynamic> states = [];
  List<dynamic> cities = [];

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(
          Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/states'));
      final data = json.decode(response.body);
      setState(() {
        states = data['states']
            .map((state) =>
                {'value': state['state_id'], 'label': state['state_name']})
            .toList();
      });
    } catch (error) {
      print('Error fetching states: $error');
    }
  }

  Future<void> fetchCities(int stateId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://cdn-api.co-vin.in/api/v2/admin/location/districts/$stateId'));
      final data = json.decode(response.body);
      setState(() {
        cities = data['districts']
            .map((district) => {
                  'value': district['district_id'],
                  'label': district['district_name']
                })
            .toList();
      });
    } catch (error) {
      print('Error fetching cities: $error');
    }
  }

  void handleStateChange(dynamic selectedOption) {
    setState(() {
      formData['state'] = selectedOption;
      formData['city'] = null;
    });
    if (selectedOption != null) {
      fetchCities(selectedOption['value']);
    } else {
      setState(() {
        cities = [];
      });
    }
  }

  void handleCityChange(dynamic selectedCity) {
    setState(() {
      formData['city'] = selectedCity;
    });
  }

  void handleSubmit() async {
    if (formKey.currentState!.validate()) {
      if (formData['state'] == null || formData['state']['label'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a state'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      if (formData['city'] == null || formData['city']['label'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a city'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }
      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Sanitize email input
      String sanitizedEmail = widget.email.replaceAll(RegExp(r'[.]'), '-');

      // Reference to Firebase database
      DatabaseReference ref = FirebaseDatabase.instance.ref('users');

      try {
        // Check if the user already exists in the database
        DataSnapshot snapshot = await ref.child(sanitizedEmail).get();
        if (snapshot.exists) {
          // User already exists, display a message
          setState(() {
            isLoading = false; // Hide loading indicator
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User with this email already exists!'),
            ),
          );
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_email", widget.email);

          // User does not exist, proceed to store new data
          final Map<String, dynamic> userData = {
            'fname': formData['fname'],
            'lname': formData['lname'],
            'email': widget.email,
            'insti': formData['insti'],
            'state': {
              'label': formData['state']['label'],
              'value': formData['state']['value'],
            },
            'city': {
              'label': formData['city']['label'],
              'value': formData['city']['value'],
            },
          };

          // Store data into Firebase
          await ref.child(sanitizedEmail).set(userData);

          print('Form submitted and data stored successfully: $userData');

          setState(() {
            isLoading = false; // Hide loading indicator
          });

          // Navigate to HomePage
          navigateToHomePage("partial_registration");
        }
      } catch (error) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        setState(() {
          isLoading = false; // Hide loading indicator in case of error
        });
        print('Failed to store data: $error');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit the form. Please try again later.'),
          ),
        );
      }
    }
  }

  void navigateToHomePage(String navigateLabel) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => HomePage(comingByWhichStep: navigateLabel)),
      (Route<dynamic> route) =>
          false, // This removes all the routes in the stack
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final specialCharExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final digitExp = RegExp(r'\d');
    if (!specialCharExp.hasMatch(value) || !digitExp.hasMatch(value)) {
      return 'Password must contain a special character and a number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First Name Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => formData['fname'] = value,
                    validator: validateName,
                  ),
                ),
                // Last Name Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => formData['lname'] = value,
                    validator: validateName,
                  ),
                ),
                // Email Input

                // Institute Name Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Institute Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => formData['insti'] = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter Institute Name' : null,
                  ),
                ),
                // State Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Select State',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: states.map((state) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: state,
                        child: Text(state['label']),
                      );
                    }).toList(),
                    onChanged: handleStateChange,
                    value: formData['state'],
                    hint: Text('Select a state'),
                  ),
                ),
                // City Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Select City',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: formData['state'] != null
                        ? cities.map((city) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: city,
                              child: Text(city['label']),
                            );
                          }).toList()
                        : [],
                    onChanged:
                        formData['state'] != null ? handleCityChange : null,
                    value: formData['city'],
                    hint: Text('Select a city'),
                    disabledHint: Text('Select a state first'),
                  ),
                ),
                // Register Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white), // Spinner color
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text('Register',
                            style: TextStyle(
                                fontSize: 16)), // Button text when not loading
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
