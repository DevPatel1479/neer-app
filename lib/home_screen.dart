import 'package:flutter/material.dart';
import 'package:neer/location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final String? comingByWhichStep;
  HomePage({this.comingByWhichStep});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instructions to use NEER"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background LinearLayout
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Adjust padding
              child: Column(
                children: [
                  SizedBox(height: 16), // Space at the top
                  Text(
                    'NEER Application is used to determine the water quality in terms of estimation of parameters like FUI Index, Turbidity, Chlorophyll, and SPM values. '
                    'These parameters are measured through camera clicking, and Temp, pH, Depth, Dissolved Oxygen, Conductivity, and Secchi Depth are manually measured through instruments. '
                    'Before that, the user has to set the location by GPS or manually, and based on that, Latitude and Longitude values can be easily fetched. '
                    'After selecting the water body, the user can select the relevant parameters of that corresponding water body. '
                    'The FUI index calculates the water index color through capturing the image of water. NEER has an easy-to-use interface that guides users through the collection of three images: a gray card image, a sky image, and a water image. '
                    'NEER requires the use of an 18% photographer’s gray card as a reference. Gray cards are widely available at photography shops and online. '
                    'Once the images are taken, they can be analyzed immediately. In the analysis of the images, NEER calculates the reflectance of the water body in the RGB color channels of the camera. '
                    'It then uses the reflectance values to determine the turbidity of the water in NTU (nephelometric turbidity units). '
                    'The Secchi Disk is a round white disk lowered into the water body to determine the Secchi Depth, which is the depth at which water can no longer be seen from the surface. '
                    'The Secchi Depth measures the clarity of the water.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF050505),
                    ),
                    textAlign: TextAlign
                        .justify, // Justify text for better readability
                  ),
                  SizedBox(height: 60), // Space for bottom button
                ],
              ),
            ),
          ),
          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 55,
              color: Color(0xFF4facfc),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button click
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LocationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF37A6F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Click to Get Location',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
