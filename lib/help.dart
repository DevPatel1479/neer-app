import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).helpScreenTitle),
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
              S.of(context).howToUse,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            buildInstructionsText(S.of(context).instruction1_1),
            buildSubInstructionsText(S.of(context).subInstruction1),
            buildSubInstructionsText(S.of(context).subInstruction2),
            buildSubInstructionsText(S.of(context).subInstruction3),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction2_2),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction3),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction4),
            buildInstructionsText(S.of(context).instruction5),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction6),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction7),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction8),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction9),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction10),
            buildInstructionsText(S.of(context).instruction11),
            buildInstructionsText(S.of(context).instruction12),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction13),
            buildInstructionsText(S.of(context).instruction14),
            buildInstructionsText(S.of(context).instruction15),
            SizedBox(height: 10),
            buildInstructionsText(S.of(context).instruction16),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action for the close button
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).closeButton,
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
