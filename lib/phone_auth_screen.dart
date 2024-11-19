import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neer/home_screen.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:intl/intl.dart'; // For formatting date and time

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref(); // Firebase Database reference
  String? verificationId;
  bool isLoading = false; // For showing progress indicator

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = _phoneController.text;

    // Validate phone number
    if (phoneNumber.length != 10 || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit phone number.")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show loading spinner
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // Add your country code
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userEmail = prefs.getString('user_email');
        String? userName = prefs.getString('user_name');

        // Get current date and time
        String createdAt =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        // Store user data into Firebase Realtime Database
        await _databaseRef.child('users').push().set({
          'email': userEmail,
          'name': userName,
          'phoneNumber': '+91$phoneNumber',
          'createdAt': createdAt,
        });

        // Navigate to home if verification is completed automatically
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), // Go to HomePage
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
        setState(() {
          isLoading = false; // Stop loading if verification failed
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        setState(() {
          isLoading = false; // Stop loading when OTP is sent
        });
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                    verificationId: verificationId,
                    status: 'signup',
                  )),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Continue with Google"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10, // Limit input to 10 digits
              decoration: InputDecoration(
                hintText: 'Enter Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator() // Show loading spinner
                : ElevatedButton(
                    onPressed: _verifyPhoneNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "Get OTP",
                      style: TextStyle(fontSize: 16), // Font size
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// OTP Verification Screen
class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String status;
  String? email;
  String? name;
  String? phone;

  OTPVerificationScreen(
      {required this.verificationId,
      required this.status,
      this.email,
      this.name,
      this.phone});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false; // For showing progress indicator
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> _verifyOTP() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );

      // Sign in with the OTP credential
      await _auth.signInWithCredential(credential);

      // Fetch SharedPreferences data after OTP is verified
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('user_email');
      String? userName = prefs.getString('user_name');
      String createdAt = DateTime.now().toString(); // Current date and time
      String phoneNumber =
          _auth.currentUser!.phoneNumber ?? ''; // User's phone number

      if (userEmail != null && userName != null) {
        String uid = _auth.currentUser!.uid;
        if (widget.status == 'signup') {
          if (widget.email != null &&
              widget.name != null &&
              widget.phone != null) {
            await prefs.setString("user_email", widget.email!);
            await prefs.setString("user_name", widget.name!);
            await prefs.setString("phone", widget.phone!);
            await _dbRef.child('users').push().set({
              'email': widget.email,
              'name': widget.name,
              'phone': widget.phone,
              'createdAt': createdAt,
            });
          } else {
            // Store user data in Firebase Realtime Database
            await _dbRef.child('users').push().set({
              'email': userEmail,
              'name': userName,
              'phone': phoneNumber,
              'createdAt': createdAt,
            });
          }
        }

        setState(() {
          isLoading = false;
        });

        // Navigate to HomePage after storing data
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), // Go to HomePage
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6, // OTP is usually 6 digits
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator() // Show loading spinner during verification
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(fontSize: 16), // Font size
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
