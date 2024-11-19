import 'package:flutter/material.dart';
import 'package:neer/fui_index_screen.dart';
import 'package:neer/optical_observation_screen.dart';
import 'package:neer/turbidity_calculation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:neer/local_database/database_helper.dart';

class SelectedEntry extends StatefulWidget {
  final List<String> selectedParameters;

  SelectedEntry({required this.selectedParameters});

  @override
  _SelectedEntryState createState() => _SelectedEntryState();
}

class _SelectedEntryState extends State<SelectedEntry> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _errors = {};
  late DatabaseReference _databaseReference;
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('observation_data');
    _fetchCurrentLocation();
    for (String parameter in widget.selectedParameters) {
      _controllers[parameter] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _latitude = prefs.getDouble('latitude');
      _longitude = prefs.getDouble('longitude');
    });
    // try {
    //   // Check for location permission
    //   LocationPermission permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //   }

    //   if (permission == LocationPermission.deniedForever) {
    //     // Location permissions are permanently denied, handle accordingly
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text('Location permissions are permanently denied.')),
    //     );
    //     return;
    //   }

    //   // Get the current position
    //   Position position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high);
    //   setState(() {
    //     _latitude = position.latitude;
    //     _longitude = position.longitude;
    //   });
    // } catch (e) {
    //   print('Error fetching location: $e');
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error fetching location: $e')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In-Situ Observation'),
        backgroundColor: Color(0xFF4FACFC),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          color: Color(0xFFEBF4FA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Color(0xFFACA1A1), thickness: 1.0, height: 12.0),
              SizedBox(height: 10),
              ..._buildInputFields(),
              SizedBox(height: 20),
              if (_buildInputFields().isNotEmpty) _buildSubmitButton(context),
              SizedBox(height: 20),
              if (_buildInputFields().isNotEmpty) _buildManualEntryText(),
              SizedBox(height: 20),
              _buildCalculationButtons(),
              if (_isLoading) // Show loading indicator if loading
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Saving data, please wait...'), // Loading text
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputFields() {
    List<Widget> inputFields = [];
    for (String parameter in widget.selectedParameters) {
      if (parameter == "FUI Index" ||
          parameter == "Turbidity" ||
          parameter == "Secchi Depth") {
        continue;
      }
      inputFields.add(_buildInputField(parameter));
    }
    return inputFields;
  }

  Widget _buildInputField(String parameter) {
    String label;
    String hint;

    switch (parameter) {
      case "Temperature":
        label = 'Temperature (°C)';
        hint = 'Enter temperature';
        break;
      case "pH":
        label = 'pH Value';
        hint = 'Enter pH value (0.0-14.0)';
        break;
      case "Water Depth":
        label = 'Water Depth (m)';
        hint = 'Enter depth value (m)';
        break;
      case "Dissolved O2":
        label = 'Dissolved O2 (ml/L)';
        hint = 'Enter O2 value (ml/L)';
        break;
      default:
        label = '';
        hint = '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          TextField(
            controller: _controllers[parameter],
            decoration: InputDecoration(
              hintText: hint,
              errorText: _errors[parameter],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // Validate fields
          if (_validateFields()) {
            // Save data to Firebase
            await _saveDataToFirebase();
          }
        },
        child: Text('Click To Save', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;
    _errors.clear();

    for (String parameter in widget.selectedParameters) {
      if (parameter == "FUI Index" ||
          parameter == "Turbidity" ||
          parameter == "Secchi Depth") {
        continue;
      }

      String? value = _controllers[parameter]?.text;

      if (value == null || value.isEmpty) {
        _errors[parameter] = 'Please enter a value';
        isValid = false;
      } else {
        switch (parameter) {
          case "Temperature":
            if (double.tryParse(value) == null) {
              _errors[parameter] = 'Invalid temperature';
              isValid = false;
            }
            break;
          case "pH":
            if (double.tryParse(value) == null ||
                double.parse(value) < 0.0 ||
                double.parse(value) > 14.0) {
              _errors[parameter] = 'pH must be between 0.0 and 14.0';
              isValid = false;
            }
            break;
          case "Water Depth":
            if (double.tryParse(value) == null) {
              _errors[parameter] = 'Invalid depth value';
              isValid = false;
            }
            break;
          case "Dissolved O2":
            if (double.tryParse(value) == null) {
              _errors[parameter] = 'Invalid O2 value';
              isValid = false;
            }
            break;
        }
      }
    }

    setState(() {});
    return isValid;
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

  Future<void> _saveDataToFirebase() async {
    String? observationTitle = await _showTitleInputDialog();
    if (observationTitle == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter title for observation")));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    String? waterBody = prefs.getString('water_body');
    if (userEmail != null) {
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      Map<String, dynamic> dataToSave = {
        'user_email': userEmail,
        'date': formattedDate,
        'time': formattedTime,
        'latitude': _latitude,
        'longitude': _longitude,
        'water_body': waterBody
      };

      for (String parameter in widget.selectedParameters) {
        if (_controllers[parameter]?.text.isNotEmpty ?? false) {
          dataToSave[parameter] = _controllers[parameter]?.text;
        }
      }

      await _databaseReference.push().set(dataToSave);

      Map<String, dynamic> observation = {
        'title': observationTitle,
        'date': formattedDate,
        'time': formattedTime,
        'latitude': _latitude,
        'longitude': _longitude,
        'turbidity': 'N/A',
        'spm': 'N/A',
        'ref_red': 0,
        'ref_green': 0,
        'ref_blue': 0,
        'temperature': dataToSave['Temperature'],
        'ph_value': dataToSave['pH'],
        'water_depth': dataToSave['Water Depth'],
        'dissolved_O2': dataToSave['Dissolved O2'],
        'secchi_depth': 0,
      };

      await DatabaseHelper.instance.insertObservation(observation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully!')),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User email not found!')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildManualEntryText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        'Click the above button to save manually entered values.',
        style: TextStyle(fontSize: 20, color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCalculationButtons() {
    List<Widget> calculationButtons = [];

    for (String parameter in widget.selectedParameters) {
      if (parameter == "FUI Index" ||
          parameter == "Turbidity" ||
          parameter == "Secchi Depth") {
        calculationButtons.add(_buildCalculationButton(parameter));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: calculationButtons,
    );
  }

  Widget _buildCalculationButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Add calculation action
        if (label == 'Secchi Depth') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OpticalObservationsScreen()));
        }
        if (label == 'FUI Index') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FUIIndexScreen()));
        }
        if (label == "Turbidity") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TurbidityCalculationScreen()));
        }
      },
      child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
