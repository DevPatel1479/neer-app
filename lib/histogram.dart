import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class HistogramApp extends StatefulWidget {
  final List<XFile?> capturedImages; // Images already captured

  HistogramApp({required this.capturedImages});

  @override
  _HistogramAppState createState() => _HistogramAppState();
}

class _HistogramAppState extends State<HistogramApp> {
  // Store histograms for each image
  List<List<int>> redHistograms = [];
  List<List<int>> greenHistograms = [];
  List<List<int>> blueHistograms = [];
  List<int> maxFrequencies = []; // Store max frequencies for each image

  @override
  void initState() {
    super.initState();
    // Initialize histograms for each image
    for (int i = 0; i < widget.capturedImages.length; i++) {
      redHistograms.add(List.filled(256, 0));
      greenHistograms.add(List.filled(256, 0));
      blueHistograms.add(List.filled(256, 0));
      maxFrequencies.add(0);
      // Compute histograms for the images as soon as the widget is initialized
      if (widget.capturedImages[i] != null) {
        _computeHistogram(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Histogram'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Gray Card'),
              Tab(text: 'Water'),
              Tab(text: 'Sky'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHistogramTab(0, 'Gray Card'),
            _buildHistogramTab(1, 'Water'),
            _buildHistogramTab(2, 'Sky'),
          ],
        ),
      ),
    );
  }

  // Build a tab for each category (Gray Card, Water, Sky)
  Widget _buildHistogramTab(int index, String title) {
    if (widget.capturedImages[index] == null) {
      return Center(child: Text('No image captured for $title'));
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('$title Histogram (Red)', style: TextStyle(fontSize: 20)),
              _buildHistogram(redHistograms[index], maxFrequencies[index],
                  1), // Red channel
              SizedBox(height: 20),
              Text('Green', style: TextStyle(fontSize: 20)),
              _buildHistogram(greenHistograms[index], maxFrequencies[index],
                  2), // Green channel
              SizedBox(height: 20),
              Text('Blue', style: TextStyle(fontSize: 20)),
              _buildHistogram(blueHistograms[index], maxFrequencies[index],
                  3), // Blue channel
            ],
          ),
        )
      ],
    );
  }

  // Widget to build the histogram for a color channel
  Widget _buildHistogram(List<int> histogram, int maxFrequency, int flag) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: CustomPaint(
        painter: HistogramPainter(histogram, maxFrequency, flag),
        child: Container(),
      ),
    );
  }

  // Compute the histogram for the given image index
  Future<void> _computeHistogram(int index) async {
    if (widget.capturedImages[index] == null) return;

    // Read image file as byte data
    Uint8List imageBytes = await widget.capturedImages[index]!.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      // Initialize separate histograms for the current image
      List<int> rHistogram = List.filled(256, 0);
      List<int> gHistogram = List.filled(256, 0);
      List<int> bHistogram = List.filled(256, 0);
      int localMaxFrequency = 0;

      // Loop through each pixel to generate the histograms
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          int pixel = image.getPixel(x, y);
          int red = img.getRed(pixel);
          int green = img.getGreen(pixel);
          int blue = img.getBlue(pixel);

          rHistogram[red]++;
          gHistogram[green]++;
          bHistogram[blue]++;

          localMaxFrequency = [
            rHistogram[red],
            gHistogram[green],
            bHistogram[blue],
            localMaxFrequency
          ].reduce((a, b) => a > b ? a : b);
        }
      }

      // Update the histograms and max frequency for this image
      setState(() {
        redHistograms[index] = rHistogram;
        greenHistograms[index] = gHistogram;
        blueHistograms[index] = bHistogram;
        maxFrequencies[index] = localMaxFrequency;
      });
    }
  }
}

class HistogramPainter extends CustomPainter {
  final List<int> histogram;
  final int maxFrequency;
  final int flag; // 1: Red, 2: Green, 3: Blue

  HistogramPainter(this.histogram, this.maxFrequency, this.flag);

  @override
  void paint(Canvas canvas, Size size) {
    double widthPerBin = size.width / 256;

    // Set the color based on the flag
    Paint paint;
    if (flag == 1) {
      paint = Paint()..color = Colors.red;
    } else if (flag == 2) {
      paint = Paint()..color = Colors.green;
    } else {
      paint = Paint()..color = Colors.blue;
    }

    // Draw the histogram
    for (int i = 0; i < 256; i++) {
      double barHeight = (histogram[i] / maxFrequency) * size.height;
      canvas.drawLine(Offset(i * widthPerBin, size.height),
          Offset(i * widthPerBin, size.height - barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
