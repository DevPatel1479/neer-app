import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:neer/grid.dart';
import 'package:neer/results_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io'; // Add this import for File
import 'package:image/image.dart' as img; // Import image package

class CameraForFui extends StatefulWidget {
  @override
  _CameraForFuiState createState() => _CameraForFuiState();
}

class _CameraForFuiState extends State<CameraForFui> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  double? _pitchValue;
  double? _gravityX = 0.0;
  double? _gravityY = 0.0;
  double? _gravityZ = 0.0;

  double? _zeroX = 0.0;
  double? _zeroY = 0.0;
  double? _zeroZ = 1.0; // Assuming zero vector as (0, 0, 1)

  bool _isCaptureEnabled = false;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // New variable to store the captured image file
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeSensors();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {});
  }

  void _initializeSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _updateGravity(event);
      _calculateAngleAndUpdateUI();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _updateGravity(AccelerometerEvent event) {
    _gravityX = event.x;
    _gravityY = event.y;
    _gravityZ = event.z;
  }

  void _calculateAngleAndUpdateUI() {
    double scale1 =
        sqrt(pow(_gravityX!, 2) + pow(_gravityY!, 2) + pow(_gravityZ!, 2));
    double cos = (_zeroX! * _gravityX! +
            _zeroY! * _gravityY! +
            _zeroZ! * _gravityZ!) /
        (scale1 * sqrt(pow(_zeroX!, 2) + pow(_zeroY!, 2) + pow(_zeroZ!, 2)));

    // Clamping the cos value
    if (cos > 1.0) {
      cos = 1.0;
    } else if (cos < -1.0) {
      cos = -1.0;
    }

    double angleInDegrees = acos(cos) * (180 / pi);

    setState(() {
      _pitchValue = angleInDegrees;
      // Enable capture if angle is within specified range
      _isCaptureEnabled =
          _pitchValue! >= 35 && _pitchValue! <= 45; // Adjust as per requirement
    });
  }

  void _captureAction() {
    if (_pitchValue != null) {
      // Set a threshold for capturing images around 40 degrees
      if (_pitchValue! >= 35 && _pitchValue! <= 45) {
        print('Capturing image at pitch angle $_pitchValue');
        _takePicture();
      } else {
        print('Angle $_pitchValue is out of range for capture');
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final image = await _controller!.takePicture();
        setState(() {
          _capturedImage = image; // Store the captured image
        });
        print('Picture saved to ${image.path}');
        _extractRgbFromImage(image.path); // Extract RGB values from the image
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  // Function to extract RGB values from the image
  Future<void> _extractRgbFromImage(String imagePath) async {
    // Load the image
    File imageFile = File(imagePath);
    List<int> imageData = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageData);

    if (image != null) {
      // Calculate RGB values from the center
      double redColors = 0.0;
      double greenColors = 0.0;
      double blueColors = 0.0;
      double pixelCount = 0.0;

      // Define the central area
      int centerX = image.width ~/ 2;
      int centerY = image.height ~/ 2;
      int halfWidth = image.width ~/ 4; // Half of the quarter width
      int halfHeight = image.height ~/ 4; // Half of the quarter height

      for (int y = centerY - halfHeight; y < centerY + halfHeight; y++) {
        for (int x = centerX - halfWidth; x < centerX + halfWidth; x++) {
          int pixel = image.getPixel(x, y);
          pixelCount++;
          redColors += img.getRed(pixel);
          greenColors += img.getGreen(pixel);
          blueColors += img.getBlue(pixel);
        }
      }

      // Calculate the average RGB values
      redColors /= pixelCount;
      greenColors /= pixelCount;
      blueColors /= pixelCount;

      // Normalize the values (0-1 range)
      double x =
          (2.7689 * redColors) + (1.7517 * greenColors) + (1.1302 * blueColors);
      double y =
          (1.0 * redColors) + (4.5907 * greenColors) + (0.0601 * blueColors);
      double z =
          (0.0 * redColors) + (0.0565 * greenColors) + (5.594 * blueColors);

      print("red : $redColors");
      print("green : $greenColors");
      print("blue : $blueColors");

      // Normalize to [0, 1]
      double sum = x + y + z;
      // if (sum > 0) {
      //   x /= sum;
      //   y /= sum;
      // }
      if (sum > 0) {
        x = x / sum;
        y = y / sum;
      }

      x = x - (1 / 3);
      y = y - (1 / 3);

      // Convert to degrees
      double arctan = _arctan(y, x);
      arctan = arctan * 2 * 3.14;

      // Step 3: Convert to degrees and divide by 1000
      arctan = (arctan * 180 / 3.14) / 1000;
      double triangle = _triangleCorrection(arctan); // Calculate triangle value
      double correctedAngle = arctan + triangle;

      // Display the results (use a Text widget in your UI to show these)
      print('X value=${x.toStringAsFixed(4)}');
      print('Y value=${y.toStringAsFixed(4)}');
      print('Angle=${arctan.toStringAsFixed(4)}');
      print('Corrected angle=${correctedAngle.toStringAsFixed(4)}');
      print('Triangle Value=${triangle.toStringAsFixed(4)} |');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ColorSelectionPage(
            capturedImage: _capturedImage,
            triangleValue: triangle, // Pass the triangle value
            xValue: x, // Pass the x value
            yValue: y, // Pass the y value
            angleValue: arctan, // Pass the angle value
            correctedAngle: correctedAngle, // Pass the corrected angle
          ),
        ),
      );
    } else {
      print('Error loading image.');
    }
  }

  double _arctan(double opp, double adj) {
    if (adj < 0.0) {
      return -(atan(opp / adj) * 57.2957795);
    } else {
      return -(atan(opp / adj) * 57.2957795) + 180;
    }
  }

  double _triangleCorrection(double arctan) {
    double triangle = (-1.8185 * pow(arctan / 100, 5)) +
        (87.01 * pow(arctan / 100, 4)) -
        (486.65 * pow(arctan / 100, 3)) +
        (1004.93 * pow(arctan / 100, 2)) -
        (844.55 * arctan / 100) +
        (220 / 28);
    return triangle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Row with Buttons
          Padding(padding: EdgeInsets.all(10.5)),
          // Water Button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _captureAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEBF4FA),
                    foregroundColor: Color(0xFF020202),
                    textStyle: TextStyle(fontSize: 15),
                  ),
                  child: Text('Water'),
                ),
              ),
            ],
          ),

          // Camera Preview or Captured Image Preview
          Expanded(
            child: _capturedImage == null
                ? (_controller == null
                    ? Center(child: CircularProgressIndicator())
                    : CameraPreview(_controller!))
                : Image.file(
                    File(_capturedImage!.path), // Display the captured image
                    fit: BoxFit.cover,
                  ),
          ),

          // New Measurement and Preview Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _capturedImage =
                          null; // Clear captured image to take a new one
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEBF4FA),
                    foregroundColor: Color(0xFF020202),
                    textStyle: TextStyle(fontSize: 15),
                  ),
                  child: Text('New Measurement'),
                ),
              ),
            ],
          ),

          // Result Section
          Container(
            height: 90,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xFF2196F3),
                    child: Image(
                      image: AssetImage('assets/one.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      _pitchValue != null
                          ? _pitchValue!.toStringAsFixed(2)
                          : '0.00', // Display pitch value
                      style: TextStyle(fontSize: 35, color: Color(0xFF040404)),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _captureAction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Image(
                      image: AssetImage('assets/objetivo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
