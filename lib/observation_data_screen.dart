// import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neer/local_database/database_helper.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'generated/l10n.dart';

class ObservationDataScreen extends StatefulWidget {
  @override
  _ObservationDataScreenState createState() => _ObservationDataScreenState();
}

class _ObservationDataScreenState extends State<ObservationDataScreen> {
  late Future<List<Map<String, dynamic>>> _observations;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _observations = fetchObservations();
  }

  Future<List<Map<String, dynamic>>> fetchObservations() async {
    final db =
        await DatabaseHelper.instance.database; // Access the singleton instance
    return await db.query('observations_data'); // Query the observations table
  }

  Future<List<Map<String, dynamic>>> fetchFilteredObservations() async {
    final db = await DatabaseHelper.instance.database;

    if (_startDate != null && _endDate != null) {
      print("Fetching observations from $_startDate to $_endDate");

      // Format the dates as strings
      String startDateStr =
          DateFormat('yyyy-MM-dd').format(_startDate!); // Change to DD-MM-YYYY
      String endDateStr = DateFormat('yyyy-MM-dd')
          .format(_endDate!.add(Duration(days: 1))); // Inclusive end date

      // Log the formatted dates
      print("Formatted Start Date: $startDateStr");
      print("Formatted End Date: $endDateStr");

      // Fetch filtered observations
      List<Map<String, dynamic>> observations = await db.rawQuery(
        'SELECT * FROM observations_data WHERE date >= ? AND date < ?',
        [startDateStr, endDateStr],
      );

      List<Map<String, dynamic>> obj =
          await db.rawQuery('SELECT * FROM observations_data');

      // Log the fetched observations

      return observations;
    } else {
      return await fetchObservations(); // No filter, return all observations
    }
  }

  // List<Map<String, dynamic>> _sortObservationsByDateAndTime(
  //     List<Map<String, dynamic>> observations) {
  //   observations.sort((a, b) {
  //     DateTime dateTimeA = DateTime.parse('${a['date']} ${a['time']}');
  //     DateTime dateTimeB = DateTime.parse('${b['date']} ${b['time']}');
  //     return dateTimeB.compareTo(
  //         dateTimeA); // Change to dateTimeB.compareTo(dateTimeA) for descending order
  //   });
  //   return observations;
  // }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1), // Dynamic last date
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime initialDate =
        _endDate ?? DateTime.now(); // Use current date if _endDate is null
    final DateTime firstDate =
        _startDate ?? DateTime(2000); // Ensure this date is valid

    // Ensure the initialDate is on or after the firstDate
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(DateTime.now().year + 1), // Dynamic last date
    );

    // Check if a date was picked and it's different from the current _endDate
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked; // Update _endDate
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).observation_data_title),
        backgroundColor: Color(0xFF4facfc),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(S.of(context).start_date),
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(_startDate == null
                        ? S.of(context).select_date
                        : DateFormat('yyyy-MM-dd').format(_startDate!)),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(S.of(context).end_date),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(_endDate == null
                        ? S.of(context).select_date
                        : DateFormat('yyyy-MM-dd').format(_endDate!)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Adjust the value as needed
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _observations = fetchFilteredObservations();
                    });
                  },
                  child: Text(S.of(context).filter_button),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _observations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(S.of(context).no_observations));
                }

                final observations = snapshot.data!;

                return ListView.builder(
                  itemCount: observations.length,
                  itemBuilder: (context, index) {
                    final observation = observations[
                        observations.length - 1 - index]; // Reverse the index

                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.primaries[index % Colors.primaries.length]
                          .withOpacity(0.8), // Colorful card
                      child: ListTile(
                        title: Text(
                          observation['title'] ?? 'No Title',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          'Date: ${observation['date']} Time: ${observation['time']}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          // Navigate to detailed view of the selected observation
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ObservationDetailScreen(
                                observationData: observation,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showDeleteConfirmationDialog(context, observation);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> observation) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext instead of context
        return AlertDialog(
          title: Text(S.of(context).delete_observation),
          content: Text(S.of(context).delete_confirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                // Perform the deletion from the database
                int id = observation['id'];
                await DatabaseHelper.instance.deleteObservation(id);
                Navigator.of(dialogContext).pop(); // Close the dialog

                // Store the deleted observation for undo functionality
                Map<String, dynamic> deletedObservation = observation;

                // Show a SnackBar for undo functionality
                if (mounted) {
                  // Ensure the widget is still mounted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).observation_deleted),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () async {
                          // Restore the deleted observation
                          await DatabaseHelper.instance
                              .insertObservation(deletedObservation);
                          // Fetch the updated list of observations after restoration
                          if (mounted) {
                            setState(() {
                              _observations = fetchFilteredObservations();
                            });
                          }
                          if (mounted) {
                            // Check if still mounted
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(S.of(context).observation_restored)),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }

                // Refresh the observations list
                setState(() {
                  _observations =
                      fetchFilteredObservations(); // Fetch updated list
                });
              },
              child: Text(S.of(context).delete_button),
            ),
          ],
        );
      },
    );
  }
}

class ObservationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> observationData;

  ObservationDetailScreen({required this.observationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(observationData['title']),
        backgroundColor: Color(0xFF4facfc),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Field',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Value',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).date)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['date'])),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).time)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['time'])),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).turbidity)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['turbidity'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).spm)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['spm'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).temperature),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (observationData['temperature']?.toString() ?? 'N/A'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).ph_value),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (observationData['ph_value']?.toString() ?? 'N/A'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).water_depth),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (observationData['water_depth']?.toString() ?? 'N/A'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).dissolved_o2),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (observationData['dissolved_O2']?.toString() ??
                              'N/A'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.of(context).secchi_depth),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (observationData['secchi_depth']?.toString() ??
                              'N/A'),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).latitude)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['latitude'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).longitude)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['longitude'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).reflectance_red)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['ref_red'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).reflectance_green)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['ref_green'].toString())),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(S.of(context).reflectance_blue)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(observationData['ref_blue'].toString())),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                S.of(context).reflectance,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light background for better UI
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: observationData['ref_red']?.toDouble() ?? 0,
                              color: Colors.red,
                              width: 20,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  observationData['ref_green']?.toDouble() ?? 0,
                              color: Colors.green,
                              width: 20,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: observationData['ref_blue']?.toDouble() ?? 0,
                              color: Colors.blue,
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        show: false, // Hide all axis titles
                      ),
                      borderData: FlBorderData(show: false), // No border
                      gridData: FlGridData(show: false), // No grid lines
                      barTouchData: BarTouchData(
                        enabled: true, // Enable touch interaction
                        touchTooltipData: BarTouchTooltipData(
                          tooltipMargin: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipRoundedRadius:
                              10, // Rounded corners for the tooltip
                          // Remove tooltipBackgroundColor or tooltipBgColor
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String label;
                            switch (group.x.toInt()) {
                              case 0:
                                label = 'Red';
                                break;
                              case 1:
                                label = 'Green';
                                break;
                              case 2:
                                label = 'Blue';
                                break;
                              default:
                                label = '';
                            }
                            return BarTooltipItem(
                              '$label: ${rod.toY}',
                              TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
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
