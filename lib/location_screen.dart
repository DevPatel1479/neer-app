import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc; // Aliasing location package
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'ecosystem_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationScreen> {
  loc.Location location = loc.Location(); // Use the aliased Location class
  bool _serviceEnabled = false;
  late loc.PermissionStatus
      _permissionGranted; // Use the aliased PermissionStatus
  String _latitude = 'Not found';
  String _longitude = 'Not found';
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();

  LatLng _currentLocation = LatLng(20.5937, 78.9629); // Centered on India
  final MapController _mapController =
      MapController(); // Controller for the map
  bool _isLocationFetched = false; // Flag to check if location is fetched

  @override
  void initState() {
    super.initState();
    checkGpsAndFetchLocation();
  }

  // Check GPS and request location permission
  Future<void> checkGpsAndFetchLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // GPS is not enabled, handle it here
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    final snackBar = SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(), // Add progress indicator
          SizedBox(width: 20),
          Text(S.of(context).fetching_location_please_wait),
        ],
      ),
      duration: Duration(days: 1), // Duration should be long until dismissed
    );

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await fetchLocation();
    // After fetching, dismiss the SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  // Fetch device location
  Future<void> fetchLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      latController.text = _latitude;
      lonController.text = _longitude;
      _currentLocation = LatLng(
          position.latitude, position.longitude); // Update current location
      _isLocationFetched = true; // Set flag to true after fetching location
    });

    // Move the map to the current location after the map is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_currentLocation, 13.0); // Zoom level set to 13
    });
  }

  // Update location based on marker drag
  void _updateLocation(LatLng newLocation) {
    setState(() {
      _currentLocation = newLocation;
      _latitude = newLocation.latitude.toString();
      _longitude = newLocation.longitude.toString();
      latController.text = _latitude;
      lonController.text = _longitude;
    });
  }

  // Function to check location and navigate
  void _goToNextScreen() async {
    if (_latitude == 'Not found' || _longitude == 'Not found') {
      ScaffoldMessenger.of(context).clearSnackBars();
      // Show a message if location is not fetched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).please_turn_on_location_services),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (latController.text != null && lonController.text != null) {
        double? lat = double.tryParse(latController.text);
        double? lon = double.tryParse(lonController.text);

        print(lat);
        print(lon);

        if (_validateCoordinates(lat, lon)) {
          print(true);
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).please_enter_valid_coordinates),
            duration: Duration(seconds: 1),
          ));

          return;
        }

        if (lat != null && lon != null) {
          await prefs.setDouble('latitude', lat);
          await prefs.setDouble('longitude', lon);
        }
      }

      // Navigate to the next screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EcosystemScreen()));
    }
  }

// Validation method for latitude and longitude
  bool _validateCoordinates(double? lat, double? lon) {
    if (lat == null || lon == null) {
      return false; // Return false if either is null
    }
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  void _updateLocationMarker() {
    double? lat = double.tryParse(latController.text);
    double? lon = double.tryParse(lonController.text);

    if (lat != null &&
        lon != null &&
        lat >= -90 &&
        lat <= 90 &&
        lon >= -180 &&
        lon <= 180) {
      setState(() {
        _currentLocation = LatLng(lat, lon); // Update current location
      });
      _mapController.move(_currentLocation, 13.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Dismiss any active SnackBars when navigating back
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true; // Allow the pop action
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).location),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Container(
              color: Color(0xFF2196F3),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        S.of(context).lat,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: latController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: S.of(context).latitude,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _updateLocationMarker(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        S.of(context).lon,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: lonController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: S.of(context).longitude,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _updateLocationMarker(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToNextScreen, // Call the new function
                      child: Text(
                        S.of(context).goto_next,
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FlutterMap(
                mapController: _mapController, // Use the map controller here
                options: MapOptions(
                  initialCenter: _isLocationFetched
                      ? _currentLocation
                      : LatLng(20.5937,
                          78.9629), // Default center if location not fetched
                  initialZoom: 13.0, // Initial zoom level
                  onTap: (tapPosition, point) {
                    // Update the location if the map is tapped
                    _updateLocation(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation,
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            // Calculate the new position based on drag
                            LatLng newPosition = LatLng(
                              _currentLocation.latitude +
                                  (details.delta.dy *
                                      0.0001), // Adjust sensitivity
                              _currentLocation.longitude +
                                  (details.delta.dx *
                                      0.0001), // Adjust sensitivity
                            );
                            _updateLocation(newPosition);
                          },
                          child: Icon(
                            Icons.location_on,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
