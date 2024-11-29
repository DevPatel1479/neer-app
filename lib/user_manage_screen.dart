import 'package:flutter/material.dart';
import 'package:neer/observation_data_screen.dart';
import 'package:neer/selected_entry_screen.dart';
import 'generated/l10n.dart';
class UserManage extends StatefulWidget {
  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  List<bool> _isChecked = List.generate(7, (index) => false);
  final List<String> _titles = [
    "Temperature",
    "pH",
    "Water Depth",
    "Dissolved O2",
    "FUI Index",
    "Turbidity",
    "Secchi Depth"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).select_parameters),
          backgroundColor: Color(0xFF4facfc),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ObservationDataScreen())),
                icon: Icon(Icons.list)),
          ]),
      body: Container(
        color: Color(0xFFEBF4FA),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              S.of(context).check_boxes_instruction,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCheckboxTile(
                      title: _titles[0],
                      icon: Icons.device_thermostat,
                      index: 0),
                  _buildCheckboxTile(
                      title: _titles[1], icon: Icons.photo, index: 1),
                  _buildCheckboxTile(
                      title: _titles[2], icon: Icons.water, index: 2),
                  _buildCheckboxTile(
                      title: _titles[3], icon: Icons.opacity, index: 3),
                  _buildCheckboxTile(
                      title: _titles[4], icon: Icons.auto_awesome, index: 4),
                  _buildCheckboxTile(
                      title: _titles[5], icon: Icons.waves, index: 5),
                  _buildCheckboxTile(
                      title: _titles[6], icon: Icons.visibility, index: 6),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Reset the selections
                    setState(() {
                      _isChecked.fillRange(0, _isChecked.length, false);
                    });
                  },
                  child: Text(
                    S.of(context).reset_button,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Submit the selections
                    List<String> selectedLabels = getSelectedLabels();
                    if (selectedLabels.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(S.of(context).select_at_least_one),
                        duration: Duration(seconds: 1),
                      ));
                    } else {
                      // Pass selectedLabels to the SelectedEntry screen
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectedEntry(
                              selectedParameters: selectedLabels)));
                    }
                  },
                  child: Text(S.of(context).submit_button, style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
      {required String title, required IconData icon, required int index}) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(fontSize: 20))),
        ],
      ),
      value: _isChecked[index],
      onChanged: (bool? value) {
        setState(() {
          _isChecked[index] = value ?? false;
        });
      },
    );
  }

  List<String> getSelectedLabels() {
    List<String> selectedLabels = [];
    for (int i = 0; i < _isChecked.length; i++) {
      if (_isChecked[i]) {
        selectedLabels.add(_titles[i]);
      }
    }
    return selectedLabels;
  }
}
