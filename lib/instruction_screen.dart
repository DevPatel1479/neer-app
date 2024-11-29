import 'package:flutter/material.dart';
import 'package:neer/first_home_screen.dart';
import 'generated/l10n.dart';

class InstructionScreen extends StatefulWidget {
  @override
  _InstructionScreenState createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  String _expandedSection = '';

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSection == section) {
        _expandedSection = ''; // Close if already open
      } else {
        _expandedSection = section; // Open the new section
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Neer App"),
      //   backgroundColor: Color.fromARGB(255, 243, 232, 232),
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {
      //       Navigator.of(context).pop(); // Navigate back to the previous screen
      //     },
      //   ),
      // ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/im.png'), // Background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg.png'), // Icon background
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Color(0xFF3284CC),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      S.of(context).crowd_sourcing,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // SizedBox(height: 10),
                  // Container(
                  //   width: 380,
                  //   height: 60,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(color: Color(0xFF3284CC)),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       'ENGLISH',
                  //       style: TextStyle(
                  //         color: Color(0xFF3284CC),
                  //         fontSize: 25,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  _buildSectionTitle(S.of(context).aboutNeer),
                  if (_expandedSection == 'About NEER?' ||
                      _expandedSection == "NEER के बारे में?" ||
                      _expandedSection == "NEER વિશે?")
                    _buildSectionContent(
                      S.of(context).projectNeerDescription,
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle(S.of(context).parametersUsed),
                  if (_expandedSection == 'What are the parameters used?' ||
                      _expandedSection ==
                          'कौन-कौन से पैरामीटर उपयोग किए गए हैं?' ||
                      _expandedSection == "કયા પરિમાણોનો ઉપયોગ થાય છે?")
                    _buildSectionContent(
                      S.of(context).waterParameters,
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle(S.of(context).app_description),
                  if (_expandedSection == 'What does this App do?' ||
                      _expandedSection == 'यह ऐप क्या करता है?' ||
                      _expandedSection == 'આ એપ્લિકેશન શું કરે છે?')
                    _buildSectionContent(
                      S.of(context).neer_app_description,
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle(S.of(context).who_are_we),
                  if (_expandedSection == 'Who are we?' ||
                      _expandedSection == "हम कौन हैं?" ||
                      _expandedSection == "અમે કોણ છીએ?")
                    _buildSectionContent(
                      S.of(context).collaborative_workgroup,
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle(S.of(context).how_to_proceed),
                  if (_expandedSection == 'How to Proceed?' ||
                      _expandedSection == 'आगे कैसे बढ़ें?' ||
                      _expandedSection == 'કેવી રીતે આગળ વધવું?')
                    _buildSectionContent(
                      S.of(context).click_get_started,
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle(S.of(context).how_will_we_use_this_data),
                  if (_expandedSection == 'How will we use this data?' ||
                      _expandedSection == 'हम इस डेटा का उपयोग कैसे करेंगे?' ||
                      _expandedSection ==
                          'અમે આ ડેટાનું ઉપયોગ કેવી રીતે કરીશું?')
                    _buildSectionContent(
                      S.of(context).collected_data_usage,
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF16AE1C),
                      minimumSize: Size(300, 70),
                      textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Add navigation or functionality here

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstHomeScreen()));
                    },
                    child: Text(S.of(context).lets_get_started),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return GestureDetector(
      onTap: () => _toggleSection(title),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(Icons.arrow_right, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF000204),
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
