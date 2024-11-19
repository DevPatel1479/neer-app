import 'package:flutter/material.dart';

class ColorDetailsScreen extends StatelessWidget {
  final String colorInfo;
  final double x;
  final double y;
  final double correctedAngle;
  final double angle;

  ColorDetailsScreen({
    required this.colorInfo,
    required this.x,
    required this.y,
    required this.correctedAngle,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Color Information: $colorInfo',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('X: ${x.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            Text('Y: ${y.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            Text(
              'Corrected Angle: ${correctedAngle.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Text('Angle: ${angle.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
