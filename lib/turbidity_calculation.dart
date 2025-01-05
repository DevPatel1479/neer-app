import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data'; // For Uint8List
import 'package:image/image.dart'
    as img; // Use the image package for image processing
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:neer/analysis_result_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';
// import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; // Import intl for formatting date and time
import 'package:path_provider/path_provider.dart'; // Import for getting the temporary directory
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart' as services;
import 'package:native_exif/native_exif.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class TurbidityCalculationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // Dynamic text size based on screen width
    double textSize =
        screenWidth * 0.05; // Adjust text size relative to screen width
    double spacing =
        screenHeight * 0.02; // Adjust spacing relative to screen height
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).instructions_for_user),
        backgroundColor: Color(0xFF4facfc),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for Guidelines
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).guidelines_to_calculate_turbidity,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20), // Spacing below header
          // Instruction Texts
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).capture_image_instruction_1,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).analyze_results_instruction_2,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).visualize_histogram_instruction_3,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).visualize_results_instruction_4,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).gray_card_angle_instruction_5,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).water_angle_instruction_6,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    S.of(context).sky_angle_instruction_7,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity, // Ensure it takes full width
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4facfc),
            fixedSize: Size(double.infinity, 50), // Full width
          ),
          onPressed: () {
            _showImageConfirmationDialog(context);
          },
          child: Text(
            S.of(context).proceed,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
  // Method to show the image confirmation dialog
  void _showImageConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).use_default_gray_card_image,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/gray_card.jpg', // Ensure this image exists in your assets
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4facfc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      // Logic to use the default gray card image
                      final XFile defaultImageFile =
                          XFile('assets/gray_card.jpg');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaptureImageScreen(
                            imageFile: defaultImageFile,
                            isGrayCardSelected: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).yes,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      // Logic for not using the default gray card image
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaptureImageScreen(
                            isGrayCardSelected: false,
                          ), // Pass no image
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).no,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
class CaptureImageScreen extends StatefulWidget {
  final XFile? imageFile; // Nullable string for the image path
  final bool isGrayCardSelected;
  CaptureImageScreen({this.imageFile, required this.isGrayCardSelected});
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}
class _CaptureImageScreenState extends State<CaptureImageScreen> {
  static const services.MethodChannel _channel =
      services.MethodChannel('com.example.neer/exif');
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  int _currentIndex = 0; // Track the current tab index
  List<XFile?> _capturedImages = [null, null, null]; // Store captured images
  List<Color> _tabColors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ]; // Default colors
  double? _pitchValue;
  double? _gravityX = 0.0;
  double? _gravityY = 0.0;
  double? _gravityZ = 0.0;
  double? _zeroX = 0.0;
  double? _zeroY = 0.0;
  double? _zeroZ = 1.0; // Assuming zero vector as (0, 0, 1)
  List<double> expT = List<double>.filled(3, 0.0);
  List<double> ISO = List<double>.filled(3, 0.0);
  bool _isCaptureEnabled = false;
  bool _isAnalysisDone = false;
  String? chlorophyll = "";
  String? Turbidity;
  String? SPM;
  String? date1;
  String? time1;
  String? date2;
  String ntu = "NTU";
  String gm = "g/m^3";
  double? tur;
  double? spm;
  late double _turbidity;
  late double _spm;
  late double _refRed;
  late double _refGreen;
  late double _refBlue;
  String? _turbidityValue;
  String? chlorophyllValue;
  String? _spmValue;
  bool isLoading = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  late double latitude;
  late double longitude;
  @override
  void initState() {
    super.initState();
    if (widget.imageFile != null) {
      _resizeAndStoreImage(widget.imageFile!);
      changeTabColor();
    }
    getCoordinates();
    expT[0] = 0.071428575;
    expT[1] = 0.071428575;
    expT[2] = 0.071428575;
    ISO[0] = 800;
    ISO[1] = 800;
    ISO[2] = 400;
    _initializeCamera();
    _initializeSensors();
  }
  void changeTabColor() {
    _tabColors[_currentIndex] = Colors.green;
    setState(() {
      _currentIndex++;
    });
  }
  Future<void> _resizeAndStoreImage(XFile imageFile) async {
    try {
      // Read the asset image file
      final ByteData bytes = await rootBundle.load('assets/gray_card.jpg');
      final Uint8List list = bytes.buffer.asUint8List();
      // Decode the image
      img.Image? originalImage = img.decodeImage(list);
      if (originalImage != null) {
        // Resize the image to 480x720
        img.Image resizedImage =
            img.copyResize(originalImage, width: 480, height: 720);
        // Convert resized image back to bytes
        final List<int> resizedBytes = img.encodeJpg(resizedImage);
        // Get the temporary directory to save the resized image
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = '${tempDir.path}/resized_gray_card.jpg';
        // Save the resized image to the temporary directory
        File tempFile = File(tempPath)..writeAsBytesSync(resizedBytes);
        setState(() {
          _capturedImages[0] = XFile(tempFile.path);
          print("Captured image path: ${_capturedImages[0]?.path}");
        });
      }
    } catch (e) {
      print("Error loading asset: $e");
    }
  }
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first; // Use the first available camera
      _controller = CameraController(camera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
      setState(() {}); // Refresh UI to show camera preview once initialized
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }
  void _initializeSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _updateGravity(event);
      _calculateAngleAndUpdateUI();
    });
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
  Future<List<List<double>>> getRGBFromImages(
      List<XFile?> capturedImages) async {
    List<List<double>> rgbValuesList = [];
    for (XFile? imageFile in capturedImages) {
      if (imageFile != null) {
        // Load the image and convert it to a Bitmap or similar format
        img.Image? image = img.decodeImage(await imageFile.readAsBytes());
        if (image != null) {
          // Calculate RGB values for the image
          List<double> rgbValues = getRGB(image);
          rgbValuesList.add(rgbValues);
        }
      }
    }
    return rgbValuesList;
  }
  void result(List<List<double>> capturedImagesRGBData) {
    List<double> Ed_RGB = capturedImagesRGBData[0];
    List<double> Lw_RGB = capturedImagesRGBData[1];
    List<double> Ls_RGB = capturedImagesRGBData[2];
    double EdR = Ed_RGB[0];
    double EdG = Ed_RGB[1];
    double EdB = Ed_RGB[2];
    double LsR = Ls_RGB[0];
    double LsG = Ls_RGB[1];
    double LsB = Ls_RGB[2];
    double LwR = Lw_RGB[0];
    double LwG = Lw_RGB[1];
    double LwB = Lw_RGB[2];
    double Wref, Sref, Gref;
    // Calculation for Red Reflectance
    Wref = LwR / (expT[1] * ISO[1]);
    Sref = 0.028 * (LsR / (expT[2] * ISO[2]));
    Gref = 17.453292519943297 * (EdR / (expT[0] * ISO[0]));
    double RrsR = (Wref - Sref) / Gref;
    // Calculation for Green Reflectance
    double GreenWref = LwG / (expT[1] * ISO[1]);
    double GreenSref = 0.028 * (LsG / (expT[2] * ISO[2]));
    double GreenGref = 17.453292519943297 * (EdG / (expT[0] * ISO[0]));
    double GreenRrsG = (GreenWref - GreenSref) / GreenGref;
    // Calculation for Blue Reflectance
    double BlueWref = LwB / (expT[1] * ISO[1]);
    double BlueSref = 0.028 * (LsB / (expT[2] * ISO[2]));
    double BlueGref = 17.453292519943297 * (EdB / (expT[0] * ISO[0]));
    double BlueRrsB = (BlueWref - BlueSref) / BlueGref;
    double refRed = (RrsR * 1000000).roundToDouble() / 1000000;
    double refGreen = (GreenRrsG * 1000000).roundToDouble() / 1000000;
    double refBlue = (BlueRrsB * 1000000).roundToDouble() / 1000000;
    double chlorophyll = computeChlorophyll(refBlue, refGreen);
    setState(() {
      chlorophyllValue = chlorophyll.toStringAsFixed(3) + " mg/L";
    });
    print("chlorophyll ${chlorophyll.toStringAsFixed(3)}");
    print("RrsR $RrsR");
    if (RrsR >= 0.049) {
      Turbidity = ">1357±0";
      SPM = ">1357±0";
      tur = 1357;
      spm = 1357;
      print("Turbidity : $Turbidity" + "$ntu");
      print("SPM : $SPM" + "$gm");
      setState(() {
        _turbidityValue = Turbidity! + ntu;
        _spmValue = SPM! + gm;
        _turbidity = tur!;
        _spm = spm!;
        _refRed = refRed;
        _refGreen = refGreen;
        _refBlue = refBlue;
      });
    } else {
      print("reflectance red $RrsR");
      tur = (27.7 * RrsR) / (0.05 - RrsR);
      if (tur != null) {
        spm = pow(10, (1.02 * log(tur!) / ln10) - 0.04) as double?;
      }
      // spm = pow(10, (1.02 * log(tur) / ln10) - 0.04)
      //     as double?; // Dart uses log for natural log

      // String formatting for turbidity and SPM values
      String Turbidity1 =
          "${tur?.toStringAsFixed(0) ?? '0'}±${(0.36 * (tur ?? 0)).toStringAsFixed(0)}";
      String SPM1 =
          "${spm?.toStringAsFixed(0) ?? '0'}±${(0.38 * (spm ?? 0)).toStringAsFixed(0)}";
      print("Turbidity : $Turbidity1" + " $ntu");
      print("SPM : $spm" + " $gm");
      setState(() {
        _turbidityValue = Turbidity1 + ntu;
        _spmValue = spm.toString() + gm;
        _turbidity = tur!;
        _spm = spm!;
        _refRed = refRed;
        _refGreen = refGreen;
        _refBlue = refBlue;
      });
    }
    print("Ref red : $refRed");
    print("Ref green : $refGreen");
    print("Ref blue : $refBlue");
  }

  // Compute Chlorophyll Value
  double computeChlorophyll(double refBlue, double refGreen) {
    double ratioBAndG = refBlue / refGreen;
    return (0.03 * (pow(ratioBAndG, 3.672243)));
  }

// Function to calculate RGB values from a decoded image
  List<double> getRGB(img.Image image) {
    double redColors = 0.0;
    double greenColors = 0.0;
    double blueColors = 0.0;
    double pixelCount = 0.0;

    // Define the region to sample
    int startY = (image.height ~/ 2) - (image.width ~/ 4);
    int endY = (image.height ~/ 2) + (image.width ~/ 4);
    int startX = (image.width ~/ 2) - (image.width ~/ 4);
    int endX = (image.width ~/ 2) + (image.width ~/ 4);

    for (int y = startY; y < endY; y++) {
      for (int x = startX; x < endX; x++) {
        // Get the pixel color at (x, y)
        int pixel = image.getPixel(x, y);
        pixelCount += 1.0;
        redColors += img.getRed(pixel).toDouble();
        greenColors += img.getGreen(pixel).toDouble();
        blueColors += img.getBlue(pixel).toDouble();
      }
    }

    return [
      redColors / pixelCount,
      greenColors / pixelCount,
      blueColors / pixelCount
    ];
  }
  void _captureImage() async {
    try {
      await _initializeControllerFuture; // Ensure the camera is initialized
      // Check the pitch value based on the current index (tab)
      if ((_currentIndex == 0 || _currentIndex == 1) &&
          _pitchValue != null &&
          _pitchValue! >= 35 &&
          _pitchValue! <= 45) {
        // Gray Card and Water tabs
        XFile image = await _controller.takePicture(); // Capture the image
        _getImageDimensions(image);
        setState(() {
          _capturedImages[_currentIndex] = image;
          _tabColors[_currentIndex] = Colors.green; // Change tab color to green

          if (_currentIndex < 2) {
            _currentIndex++; // Auto-navigate to the next tab
          }
        });
      } else if (_currentIndex == 2 &&
          _pitchValue != null &&
          _pitchValue! >= 125 &&
          _pitchValue! <= 135) {
        // Sky tab
        XFile image = await _controller.takePicture(); // Capture the image

        setState(() {
          _capturedImages[_currentIndex] = image;
          _tabColors[_currentIndex] = Colors.green; // Change tab color to green

          if (_currentIndex < 2) {
            _currentIndex++; // Auto-navigate to the next tab
          }
        });
      } else {
        // Optionally show a message or handle cases where the pitch value doesn't meet criteria
        print("Pitch value out of range for capture.");
      }
    } catch (e) {
      print(e);
    }
  }
  void _getImageDimensions(XFile imageFile) async {
    try {
      // Load the image file
      final file = File(imageFile.path);
      final bytes = await file.readAsBytes();

      // Use the callback to get the decoded image dimensions
      ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image image) {
        final width = image.width;
        final height = image.height;

        print('Image width: $width, height: $height');
      });
    } catch (e) {
      print("Error getting image dimensions: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the camera controller when done
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<double?> getIsoSpeed(String imagePath) async {
    final tags = await Exif.fromPath(imagePath);
    final attributes = await tags.getAttributes();

    if (attributes != null && attributes.containsKey("ISOSpeedRatings")) {
      final isoSpeed = attributes["ISOSpeedRatings"];
      double? iso = double.tryParse(isoSpeed.toString());
      print("ISO Speed Ratings: $iso");
      print("Runtime Type: ${isoSpeed.runtimeType}");
      return iso; // Return ISO value
    } else {
      print("ISOSpeedRatings key not found or attributes are null.");
      return 0.0; // Return null if not found
    }
  }

  Future<double?> getExposureTime(String imagePath) async {
    final tags = await Exif.fromPath(imagePath);
    final attributes = await tags.getAttributes();

    if (attributes != null && attributes.containsKey("ExposureTime")) {
      var exposureValue = attributes["ExposureTime"];
      if (exposureValue is String) {
        double exposureTime =
            double.tryParse(exposureValue) ?? 0.0; // Parse String to double
        print("Exposure Time: $exposureTime");
        return exposureTime; // Return Exposure Time value
      }
    } else {
      print("ExposureTime key not found or attributes are null.");
      return 0.0; // Return null if not found
    }
    return 0.0;
  }

  void _showPreview() async {
    // print(_capturedImages[0]);
    // final String imagePath = _capturedImages[0]!.path;

    // final tags = await Exif.fromPath(imagePath);

    // final attributes = await tags.getAttributes();

    // if (attributes != null && attributes.containsKey("ISOSpeedRatings")) {
    //   final isoSpeed = attributes["ISOSpeedRatings"];
    //   double iso = double.tryParse(isoSpeed.toString())!;
    //   print(iso);
    //   print("ISO Speed Ratings: $isoSpeed");
    //   print("Runtime Type: ${isoSpeed.runtimeType}");
    // } else {
    //   print("ISOSpeedRatings key not found or attributes are null.");
    // }

    // if (attributes != null && attributes.containsKey("ExposureTime")) {
    //   var exposureValue = attributes["ExposureTime"];
    //   if (exposureValue is String) {
    //     double exposureTime =
    //         double.tryParse(exposureValue) ?? 0.0; // Parse String to double
    //     print(exposureTime);
    //   }
    // }
    // final Uint8List imageData = await File(imagePath).readAsBytes();

    // final val = await _channel.invokeMethod('processImage', {
    //   'imageData': imageData,
    // });

    // print(val);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(capturedImages: _capturedImages),
      ),
    );
  }

// Function to get current location
  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled, show an error
  //     print('Location services are disabled.');
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, show an error
  //       print('Location permissions are denied.');
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are permanently denied, show an error
  //     print('Location permissions are permanently denied.');
  //     return Future.error('Location permissions are permanently denied');
  //   }

  //   // When permission is granted, return the current position
  //   return await Geolocator.getCurrentPosition();
  // }

  void getCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble("latitude")!;
      longitude = prefs.getDouble("longitude")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Buttons for Analysis and Result

            Row(
              children: [
                _buildCustomButton("Analysis", () async {
                  // Handle Analysis button press
                  // Add your analysis action here
                  setState(() {
                    isLoading = true;
                  });
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                  String formattedTime =
                      DateFormat('HH:mm:ss').format(now); // Format current time

                  print("Current Date: $formattedDate");
                  print("Current Time: $formattedTime");

                  String date = formattedDate;
                  String time = formattedTime;
                  for (var image in _capturedImages) {
                    if (image == null) {
                      setState(() {
                        isLoading = false;
                      });
                      // Show a popup if any image is missing
                      _showPopupMessage("Please capture all images.");
                      return;
                    }
                  }

                  double? expt1 =
                      await getExposureTime(_capturedImages[0]!.path);
                  double? expt2 =
                      await getExposureTime(_capturedImages[1]!.path);
                  double? expt3 =
                      await getExposureTime(_capturedImages[2]!.path);

                  print("exp1 : $expt1");
                  print("exp2 : $expt2");
                  print("exp3 : $expt3");

                  double? iso1 = await getIsoSpeed(_capturedImages[0]!.path);
                  double? iso2 = await getIsoSpeed(_capturedImages[1]!.path);
                  double? iso3 = await getIsoSpeed(_capturedImages[2]!.path);

                  print("iso1 : $iso1");
                  print("iso2 : $iso2");
                  print("iso3 : $iso3");

                  setState(() {
                    if (expt1 != null && expt2 != null && expt3 != null) {
                      if (expt1 == 0.0) {
                        expT[0] = 0.078;
                      } else {
                        expT[0] = expt1;
                      }

                      expT[1] = expt2;
                      expT[2] = expt3;
                    }
                    if (iso1 != null && iso2 != null && iso3 != null) {
                      if (iso1 == 0.0) {
                        iso1 = 800;
                      } else {
                        ISO[0] = iso1!;
                      }

                      ISO[1] = iso2;
                      ISO[2] = iso3;
                    }
                  });

                  List<List<double>> rgbValues =
                      await getRGBFromImages(_capturedImages);
                  print("RGB of images  $rgbValues");

                  if (_isAnalysisDone == false) {
                    result(rgbValues);
                    setState(() {
                      _isAnalysisDone = true;
                    });
                  } else {
                    if (_turbidity < 1357) {
                      String turbidityValue =
                          "${_turbidity.toStringAsFixed(0)}±${(0.36 * _turbidity).toStringAsFixed(0)}";
                      String spmValue =
                          "${_spm.toStringAsFixed(0)}±${(0.38 * _spm).toStringAsFixed(0)}";

                      print("Turbidity value : $turbidityValue" + " $ntu");
                      print("SPM value : $spm" + " $gm");
                      _turbidityValue = turbidityValue + ntu;
                      _spmValue = spm.toString() + gm;
                      print("analysis is already done .... ");
                    } else {
                      print("Turbidity value : >1357\u00b10");
                      print("SPM value :>1357\u00b10");
                      _turbidityValue = ">1357\u00b10";
                      _spmValue = ">1357\u00b10";
                    }
                  }
                  print("Ref. Red : $_refRed");
                  print("Ref. Green : $_refGreen");
                  print("Ref. Blue : $_refBlue");

                  setState(() {
                    isLoading = false;
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnalysisResultScreen(
                            date: date,
                            time: time,
                            turbidity: _turbidityValue!,
                            chlorophyll: chlorophyllValue!,
                            spm: _spmValue!,
                            latitude: latitude,
                            longitude: longitude,
                            refRed: _refRed,
                            refGreen: _refGreen,
                            refBlue: _refBlue,
                            capturedImages: _capturedImages,
                          )));
                }),
                SizedBox(width: 55), // Space between buttons
                // _buildCustomButton("Result", () {
                //   // Handle Result button press
                //   // Add your result action here
                //   for (var image in _capturedImages) {
                //     if (image == null) {
                //       // Show a popup if any image is missing
                //       _showPopupMessage("Please capture all images.");
                //       return;
                //     }
                //   }
                // }),
              ],
            ),
            // Buttons for Analysis and Result
          ],
        ),
        backgroundColor: Color(0xFF4facfc),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabButton("Gray Card", 0),
              _buildTabButton("Water", 1),
              _buildTabButton("Sky", 2),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text(S.of(context).analyzing),
                ],
              ),
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      // Camera Preview
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.69, // Set height to 65% of screen height
                        child: CameraPreview(
                            _controller), // Full height camera preview
                      ),
                      // Space between camera view and preview button
                      SizedBox(height: 5.0),
                      // Preview button below the camera view
                      Container(
                        width: double
                            .infinity, // Make the container fill the available width
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0), // Add horizontal padding
                        child: ElevatedButton(
                          onPressed: _showPreview,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity,
                                35), // Make button height consistent
                          ),
                          child: Text(S.of(context).preview_images),
                        ),
                      ),
                      // Image below the preview button on the left side
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                _currentIndex == 2
                                    ? 'assets/two.png' // Show two.png for Sky tab
                                    : 'assets/one.png', // Show one.png for Gray Card and Water tabs
                                width: 100,
                                height: 55,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ), // Space between the preview button and the bottom of the screen
                          Container(
                            margin: EdgeInsets.only(
                                left:
                                    10), // Add some space between image and text
                            child: Text(
                              _pitchValue != null
                                  ? _pitchValue!.toStringAsFixed(2)
                                  : '0.00', // Display pitch value
                              style: TextStyle(
                                  fontSize: 35, color: Color(0xFF040404)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child:
                              SizedBox()), // This will take the remaining space below the preview button
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                          Text("Error initializing camera: ${snapshot.error}"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ), // Image button at the bottom right corner of the screen
      floatingActionButton: SizedBox(
        width: 70.0, // Set the width of the FloatingActionButton
        height: 70.0, // Set the height of the FloatingActionButton
        child: FloatingActionButton(
          onPressed: () {
            if (_currentIndex == 0 && widget.isGrayCardSelected) {
              // Prevent capturing image if Gray Card tab is selected

              _showPopupMessage(
                  "Cannot capture image in Gray Card tab when you have selected default gray card image.");
            } else {
              _captureImage(); // Capture image only if not in Gray Card tab
            }
          },
          backgroundColor: Colors.blue, // Optional: Set background color
          child: Image.asset(
            'assets/objetivo.png',
            fit: BoxFit.contain, // Use BoxFit to maintain aspect ratio
            width: 100.0, // Width of the image
            height: 100.0, // Height of the image
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).capture),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomButton(String label, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(8), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            label,
            style: TextStyle(color: Color(0xFF4facfc)), // Text color
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Container(
      color: _tabColors[index], // Background color for the tab
      child: TextButton(
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Text(
          label,
          style: TextStyle(color: Colors.black), // Text color
        ),
      ),
    );
  }
}

// Preview Screen for showing captured images
class PreviewScreen extends StatelessWidget {
  final List<XFile?> capturedImages;

  PreviewScreen({required this.capturedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).captured_images_preview),
        backgroundColor: Color(0xFF4facfc),
      ),
      body: ListView.builder(
        itemCount: capturedImages.length,
        itemBuilder: (context, index) {
          String label = "";
          if (index == 0)
            label = "Gray Card";
          else if (index == 1)
            label = "Water";
          else if (index == 2) label = "Sky";

          return capturedImages[index] != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.file(File(capturedImages[index]!.path)),
                    SizedBox(height: 20),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).no_image_captured(label.toString()),
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
        },
      ),
    );
  }
}
