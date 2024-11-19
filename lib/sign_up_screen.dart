import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neer/home_screen.dart';
import 'package:neer/new_registration.dart';
import 'package:neer/partial_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];
  String? selectedState;
  String? selectedCity;
  Map<String, dynamic> formData = {
    'state': null,
    'city': null
  }; // Initial form data
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController instituteNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  ); // Initialize GoogleSignIn
  bool _isSigningIn = false; // Flag to track sign-in state
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    fetchStates(); // Fetch states when widget is initialized
    super.dispose();
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(
          Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/states'));
      final data = json.decode(response.body);
      setState(() {
        states = List<Map<String, dynamic>>.from(data['states'].map((state) =>
            {'value': state['state_id'], 'label': state['state_name']}));
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
        cities = List<Map<String, dynamic>>.from(data['districts'].map(
            (district) => {
                  'value': district['district_id'],
                  'label': district['district_name']
                }));
      });
    } catch (error) {
      print('Error fetching cities: $error');
    }
  }

  // Method to show a dialog for collecting user information
  Future<void> _collectAdditionalUserInfo(String email) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Complete Your Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(hintText: "First Name"),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(hintText: "Last Name"),
                ),
                TextField(
                  controller: instituteNameController,
                  decoration: InputDecoration(hintText: "Institute Name"),
                ),
                DropdownButton<String>(
                  hint: Text("Select State"),
                  value: selectedState,
                  items: states.map((state) {
                    return DropdownMenuItem<String>(
                      value: state['value'].toString(),
                      child: Text(state['label']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedState = newValue;
                      selectedCity = null; // Reset city when state changes
                      cities
                          .clear(); // Clear cities when a new state is selected
                    });
                    if (newValue != null) {
                      fetchCities(int.parse(
                          newValue)); // Fetch cities for the selected state
                    }
                  },
                ),
                DropdownButton<String>(
                  hint: Text("Select City"),
                  value: selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city['value'].toString(),
                      child: Text(city['label']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_validateFields()) {
                  setState(() {
                    isLoading = true; // Start loading
                  });

                  // Fetch labels for the selected state and city
                  String stateLabel = states.firstWhere((state) =>
                      state['value'].toString() == selectedState)['label'];
                  String cityLabel = cities.firstWhere((city) =>
                      city['value'].toString() == selectedCity)['label'];

                  // Sanitize the email
                  String sanitizedEmail =
                      email.replaceAll('@', '-').replaceAll('.', '-');

                  // Prepare user data to store
                  Map<String, dynamic> userData = {
                    'email': sanitizedEmail,
                    'fname': firstNameController.text,
                    'lname': lastNameController.text,
                    'insti': instituteNameController.text,
                    'state': {'label': stateLabel, 'value': selectedState},
                    'city': {'label': cityLabel, 'value': selectedCity},
                  };

                  try {
                    // Store user data in Firebase Realtime Database
                    DatabaseReference ref = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(sanitizedEmail);
                    await ref.set(userData);
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate to HomePage or show success message
                  } catch (e) {
                    // Handle error (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  } finally {
                    setState(() {
                      isLoading = false; // Stop loading
                    });
                  }
                } else {
                  // Show validation error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields.")),
                  );
                }
              },
              child: isLoading
                  ? CircularProgressIndicator() // Show progress indicator when loading
                  : Text("Submit"), // Show submit button
            ),
          ],
        );
      },
    );
  }

// Ensure _validateFields() method checks all fields
  // bool _validateFields() {
  //   return firstNameController.text.isNotEmpty &&
  //       lastNameController.text.isNotEmpty &&
  //       instituteNameController.text.isNotEmpty &&
  //       selectedState != null &&
  //       selectedCity != null;
  // }

  // Validation method to check if all fields are filled
  bool _validateFields() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        instituteNameController.text.isNotEmpty &&
        selectedState != null &&
        selectedCity != null;
  }

  void navigateToHomePage(String navigateLabel) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => HomePage(comingByWhichStep: navigateLabel)),
      (Route<dynamic> route) =>
          false, // This removes all the routes in the stack
    );
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Email validation regex pattern
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);

    if (email.isNotEmpty && password.isNotEmpty) {
      // Validate email format
      if (!regExp.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email address.'),
          ),
        );
        return; // Exit the function if email is invalid
      }

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Sanitize email input
      String sanitizedEmail = email.replaceAll(RegExp(r'[.]'), '-');

      // Reference to Firebase database
      DatabaseReference ref = FirebaseDatabase.instance.ref('users');

      try {
        // Fetch user data from Firebase
        DataSnapshot snapshot = await ref.child(sanitizedEmail).get();

        if (snapshot.exists) {
          // User exists, retrieve stored hashed password
          Map<dynamic, dynamic> userData = snapshot.value
              as Map<dynamic, dynamic>; // Use Map<dynamic, dynamic>

          String storedHashedPassword =
              userData['pass'] as String; // Cast to String

          // Hash the entered password
          String hashedPassword =
              sha256.convert(utf8.encode(password)).toString();

          // Compare the entered hashed password with the stored hashed password
          if (hashedPassword == storedHashedPassword) {
            // Passwords match, login successful
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_email', email); // Store user email

            setState(() {
              _isLoading = false; // Hide loading indicator
            });

            print('Login successful for user: ${userData['email']}');

            // Navigate to HomeScreen
            navigateToHomePage("login_label");
          } else {
            // Passwords do not match, show error
            setState(() {
              _isLoading = false; // Hide loading indicator
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Incorrect password. Please try again.'),
              ),
            );
          }
        } else {
          // User does not exist, show error
          setState(() {
            _isLoading = false; // Hide loading indicator
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email not found. Please sign up.'),
            ),
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false; // Hide loading indicator in case of error
        });
        print('Failed to login: $error');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login. Please try again later.'),
          ),
        );
      }
    } else {
      // Show an error message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email and password.'),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true; // Show progress indicator
    });

    // Show a dialog with CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Signing In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please wait while we sign you in...'),
            ],
          ),
        );
      },
    );

    try {
      print("Initiating Google Sign-In");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("Google sign-in was cancelled by user.");
        Navigator.of(context).pop(); // Dismiss the progress dialog
        setState(() {
          _isSigningIn = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      String email = userCredential.user!.email!;

      // Sanitize the email to match your Firebase key format
      String sanitizedEmail = email.replaceAll('.', '-');

      // Check if the email exists in Firebase Realtime Database
      final DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child('users');
      DatabaseEvent event = await usersRef.child(sanitizedEmail).once();

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // print("new email");
        // User already exists, navigate to home
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_email", email);

        Navigator.of(context).pop(); // Dismiss the progress dialog
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomePage()),
          (Route<dynamic> route) =>
              false, // This removes all the routes in the stack
        );
      } else {
        // User does not exist, collect additional information
        // await _collectAdditionalUserInfo(email);
        // print("existing email");
        Navigator.of(context).pop(); // Dismiss the progress dialog
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => PartialRegistrationScreen(email: email)),
        );
      }
    } catch (error) {
      print("Error signing in with Google: $error");

      Navigator.of(context).pop(); // Dismiss the progress dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sign-In Failed"),
          content: Text("An error occurred during sign-in: $error"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize =
        MediaQuery.of(context).size; // Get screen size for responsiveness
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        centerTitle: true,
        backgroundColor: Colors.cyan, // Set the app bar color
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Display circular progress indicator
                  SizedBox(
                      height: 20), // Space between the indicator and the text
                  Text(
                    'Logging in, please wait...', // Loading message
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            )
          : Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.cyan, Colors.blueAccent],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.1),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true, // Hide password input
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity, // Responsive button width
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _login, // Disable button if loading
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  )
                                : Text(
                                    'LOGIN',
                                    style: TextStyle(color: Colors.black),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double
                              .infinity, // Ensure this button has full width
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle sign-up logic
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                            },
                            child: Text(
                              'CREATE NEW ACCOUNT',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'OR',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signInWithGoogle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: BorderSide(color: Colors.black),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
