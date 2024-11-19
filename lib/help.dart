import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Action to go back
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HOW TO USE IT:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            buildInstructionsText('1. Capture 3 images:'),
            buildSubInstructionsText('(i) Photographer’s 18% gray card'),
            buildSubInstructionsText('(ii) Water image'),
            buildSubInstructionsText('(iii) Sky image'),
            SizedBox(height: 10),
            buildInstructionsText(
                '2. When capturing images, make sure the sun position is left side or right side behind you, but not in front of you.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '3. The gray card is a piece of paper or cardboard with a known 18% reflectance value (similar to Kodak’s 18% reflectance). They can be purchased at photography shops or online.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '4. The first image you need to collect is the photographer\'s gray card. Place the card on a level surface that is unsaturated. Be sure the card is in an unsaturated area where you plan to take the water image.'),
            buildInstructionsText(
                '5. Ensure your shadow is not covering the card.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '6. The angle of the mobile for image of gray card and water must be 35 to 55 degrees, and for sky, the angle must be 125 to 135 degrees.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '7. A clinometer at the bottom will direct you to the correct angle to take the photograph. When the angle is correct, the circle will become full, and the border of the blue bubble will be red.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '8. For best results, use NIR if the present areas are accessible. If the bottom areas shrink, this area is too shallow to be NIR.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '9. After capturing all three images, the analysis button will calculate and display the reflectance data.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '10. The images are saved in your mobile’s NIR folder.'),
            buildInstructionsText(
                '11. You can also see the Histogram of all images.'),
            buildInstructionsText(
                '12. You can save the data locally and also upload it to the server.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '13. The result button will display all previous records. You can filter all results based on your choice.'),
            buildInstructionsText(
                '14. For new measurement, click on “new measurement button.”'),
            buildInstructionsText(
                '15. You can enter latitude and longitude for your options and also touch on the map to zoom.'),
            SizedBox(height: 10),
            buildInstructionsText(
                '16. Similarly, TUI index calculates the index color through capturing the image of water and the Secchi depth measures the clarity of water.'),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action for the close button
                  Navigator.of(context).pop();
                },
                child: Text(
                  'CLOSE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInstructionsText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  Widget buildSubInstructionsText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
      ),
    );
  }
}
