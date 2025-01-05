import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:neer/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart'; // For sha256 hashing
import 'generated/l10n.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VolunteerYourself(),
    );
  }
}

class VolunteerYourself extends StatefulWidget {
  @override
  _VolunteerYourselfState createState() => _VolunteerYourselfState();
}

class _VolunteerYourselfState extends State<VolunteerYourself> {
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
      print(formData);
      if (formData['state'] == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).please_select_a_state),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      if (formData['city'] == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).please_select_a_city),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Sanitize email input
      String sanitizedEmail = formData['email'].replaceAll(RegExp(r'[.]'), '-');

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
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).user_with_this_email_already_exists),
            ),
          );
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_email", formData["email"]);

          String hashedPassword =
              sha256.convert(utf8.encode(formData['pass'])).toString();
          String hashedPassConf =
              sha256.convert(utf8.encode(formData['pass_conf'])).toString();
          // User does not exist, proceed to store new data
          final Map<String, dynamic> userData = {
            'fname': formData['fname'],
            'lname': formData['lname'],
            'email': formData['email'],
            'insti': formData['insti'],
            'state': {
              'label': formData['state']['label'],
              'value': formData['state']['value'],
            },
            'city': {
              'label': formData['city']['label'],
              'value': formData['city']['value'],
            },
            'pass': hashedPassword,
            'pass_conf': hashedPassConf,
            'gender': null,
            'phone': null,
          };

          // Store data into Firebase
          await ref.child(sanitizedEmail).set(userData);

          print('Form submitted and data stored successfully: $userData');

          setState(() {
            isLoading = false; // Hide loading indicator
          });

          // Navigate to HomePage
          navigateToHomePage("new account");
        }
      } catch (error) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        setState(() {
          isLoading = false; // Hide loading indicator in case of error
        });
        print('Failed to store data: $error');
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).failed_to_submit_form),
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
        title: Text(S.of(context).create_new_account),
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
                      labelText: S.of(context).firstName,
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
                      labelText: S.of(context).lastName,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => formData['lname'] = value,
                    validator: validateName,
                  ),
                ),
                // Email Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).email,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) => formData['email'] = value,
                    validator: validateEmail,
                  ),
                ),
                // Institute Name Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).instituteName,
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
                      labelText: S.of(context).selectState,
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
                    hint: Text(S.of(context).selectState),
                  ),
                ),
                // City Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: S.of(context).selectCity,
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
                    hint: Text(S.of(context).selectCity),
                    disabledHint: Text(S.of(context).select_a_state_first),
                  ),
                ),
                // Password Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).password,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    obscureText: true,
                    onChanged: (value) => formData['pass'] = value,
                    validator: validatePassword,
                  ),
                ),
                // Confirm Password Input
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: S.of(context).confirm_password,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    obscureText: true,
                    onChanged: (value) => formData['pass_conf'] = value,
                    validator: (value) {
                      if (value != formData['pass']) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
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
                        : Text(S.of(context).register,
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
