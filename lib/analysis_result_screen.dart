import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neer/histogram.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
// import 'package:neer/local_database/database_helper.dart';
import 'generated/l10n.dart';

class AnalysisResultScreen extends StatefulWidget {
  final String date;
  final String time;
  final String turbidity;
  final String chlorophyll;
  final String spm;
  final double latitude;
  final double longitude;
  final double refRed;
  final double refGreen;
  final double refBlue;

  final List<XFile?> capturedImages;

  AnalysisResultScreen({
    required this.date,
    required this.time,
    required this.turbidity,
    required this.chlorophyll,
    required this.spm,
    required this.latitude,
    required this.longitude,
    required this.refRed,
    required this.refGreen,
    required this.refBlue,
    required this.capturedImages,
  });

  @override
  _AnalysisResultScreenState createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  bool _isLoading = false; // Loading state for CircularProgressIndicator
  bool _locallyAlreadySaved = false;
  bool _dataUploaded = false;
  @override
  void initState() {
    super.initState();
    // deleteDb();
  }

  // Future<void> deleteDb() async {
  //   await DatabaseHelper.instance.deleteDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).analysis_results),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.lightBlue[50],
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  children: [
                    _buildTableRow(S.of(context).date, widget.date),
                    _buildTableRow(S.of(context).time, widget.time),
                    _buildTableRow(
                        S.of(context).turbidity, "${widget.turbidity}"),
                    _buildTableRow(S.of(context).spm, "${widget.spm}"),
                    _buildTableRow(
                        S.of(context).chlorophyll, "${widget.chlorophyll}"),
                    _buildTableRow(
                        S.of(context).latitude, widget.latitude.toString()),
                    _buildTableRow(
                        S.of(context).longitude, widget.longitude.toString()),
                    _buildTableRow(
                        S.of(context).ref_red, widget.refRed.toString()),
                    _buildTableRow(
                        S.of(context).ref_green, widget.refGreen.toString()),
                    _buildTableRow(
                        S.of(context).ref_blue, widget.refBlue.toString()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Wrap buttons in Flexible or Expanded to ensure they adapt to available space
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Show Histogram Button
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HistogramApp(
                              capturedImages: widget.capturedImages)));
                    },
                    child: Text(
                      S.of(context).histogram,
                      style: TextStyle(fontSize: 16), // Adjusted font size
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Spacing between buttons
                // Save Button
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_locallyAlreadySaved == true) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(S.of(context).data_already_saved),
                            duration: Duration(seconds: 1)));
                      } else {
                        _showSaveDialog(context); // Show the save dialog
                      }
                    },
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Spacing between buttons
                // Upload Button
                Flexible(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_dataUploaded == true) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          S.of(context).data_already_uploaded),
                                      duration: Duration(seconds: 1)));
                            } else {
                              _uploadData(context);
                            }
                          },
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            S.of(context).upload,
                            style: TextStyle(fontSize: 16),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadData(BuildContext context) async {
    // if (_dataUploaded == true) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("Data already uploaded !!"),
    //     duration: Duration(seconds: 1),
    //   ));
    // }

    setState(() {
      _isLoading = true; // Start loading
    });

    // Fetch user email from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail =
        prefs.getString('user_email'); // Adjust the key as needed
    String? waterBody = prefs.getString('water_body');

    // Prepare the data to be uploaded
    final Map<String, dynamic> data = {
      'date': widget.date,
      'time': widget.time,
      'water_body': waterBody,
      'turbidity': widget.turbidity,
      'spm': widget.spm,
      'chloro': widget.chlorophyll,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'ref_red': widget.refRed,
      'ref_green': widget.refGreen,
      'ref_blue': widget.refBlue,
      'user_email': userEmail,
    };

    // Upload data to Firebase Realtime Database
    DatabaseReference ref = FirebaseDatabase.instance.ref('observation_data');
    await ref.push().set(data).then((_) {
      // Show success message

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).data_uploaded_successfully),
        duration: Duration(seconds: 1),
      ));
      setState(() {
        _dataUploaded = true;
      });
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading data: $error'),
      ));
    });

    // Stop loading
    setState(() {
      _isLoading = false;
    });

    // Pop two screens
    // Navigator.of(context).pop(); // Pop current screen
    // Navigator.of(context).pop(); // Pop previous screen
  }

  // Helper method to build a table row
  TableRow _buildTableRow(String key, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Method to show a dialog for saving observation title
  void _showSaveDialog(BuildContext context) {
    String title = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).enter_observation_title),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration:
                InputDecoration(hintText: S.of(context).observation_title),
          ),
          actions: [
            TextButton(
              child: Text(S.of(context).done),
              onPressed: () {
                if (title.isNotEmpty) {
                  _saveData(title); // Call the save method
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(S.of(context).data_saved),
                    duration: Duration(seconds: 1),
                  ));
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(S.of(context).please_enter_title_for_observation),
                  ));
                }
              },
            ),
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to save data into SQLite database
  Future<void> _saveData(String title) async {
    // Get a reference to the database
    final database = await _initializeDatabase();

    // Prepare the data to be inserted
    final Map<String, dynamic> data = {
      'title': title,
      'date': widget.date,
      'time': widget.time,
      'turbidity': widget.turbidity,
      'spm': widget.spm,
      'chlorophyll': widget.chlorophyll,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'ref_red': widget.refRed,
      'ref_green': widget.refGreen,
      'ref_blue': widget.refBlue,
    };

    // Insert the data into the database
    await database.insert('observations_data', data);

    setState(() {
      _locallyAlreadySaved = true;
    });
  }

  // Method to initialize the SQLite database
  Future<Database> _initializeDatabase() async {
    // Define the path for the database
    String path = join(await getDatabasesPath(), 'observations_data.db');

    // Open the database and create the table if it doesn't exist
    return await openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE observations_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            turbidity TEXT,
            spm TEXT,
            chlorophyll TEXT,
            latitude REAL,
            longitude REAL,
            ref_red REAL,
            ref_green REAL,
            ref_blue REAL,
            temperature REAL,      
            ph_value REAL,        
            water_depth REAL,     
            dissolved_O2 REAL,
            secchi_depth REAL
          )
        ''');
      },
    );
  }
}
