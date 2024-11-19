import 'package:flutter/material.dart';
import 'package:neer/first_home_screen.dart';

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
                      'Crowd Sourcing to Find and Report Water Quality Parameters',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 380,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF3284CC)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'ENGLISH',
                        style: TextStyle(
                          color: Color(0xFF3284CC),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildSectionTitle('About NEER?'),
                  if (_expandedSection == 'About NEER?')
                    _buildSectionContent(
                      'Project NEER was conceived by Department of Computer Science, Gujarat University under intellectual guidance from Space Application Centre (SAC), Indian Space Research Organisation (ISRO). The project is sponsored by Department of Science and Technology (DST), India for the year 2021-2024. The main objective of the project is to exploit the power of Citizen Science tools in monitoring water bodies and managing water resources division support system.',
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle('What are the parameters used?'),
                  if (_expandedSection == 'What are the parameters used?')
                    _buildSectionContent(
                      'Turbidity, FUI index, chlorophyll, temperature, pH, DO, Conductivity, Secchi depth.',
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle('What does this App do?'),
                  if (_expandedSection == 'What does this App do?')
                    _buildSectionContent(
                      'This NEER Application will provide the important information about the water quality parameters of inland water bodies. A registered volunteer now a citizen scientist captures photo of water body and measures chemical properties through instrument. The measured data is sent to a remote server tagged with location of volunteer, date and time of observation. The collected data repository on a hosted server is available for further analysis.',
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle('Who are we?'),
                  if (_expandedSection == 'Who are we?')
                    _buildSectionContent(
                      'We are a collaborative workgroup of scientists (SAC), professors (Gujarat University), research scholars and citizen scientists working collectively on the major water issues.',
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle('How to Proceed?'),
                  if (_expandedSection == 'How to Proceed?')
                    _buildSectionContent(
                      'Click the “Let’s get started” button to move on to the user information page. Continue to set the location, Select the water body and enter the information manually. Images of water, Gray card and sky are taken for Turbidity, chlorophyll and FUI index estimation. Be sure to touch the save button on the bottom of each page. Individual page instructs that how to proceed to next. The final tab helps to submit the user data.',
                    ),
                  SizedBox(height: 15),
                  _buildSectionTitle('How will we use this data?'),
                  if (_expandedSection == 'How will we use this data?')
                    _buildSectionContent(
                      'The collected data will be used to analyze the water quality and improve the monitoring processes. This data helps in understanding water quality parameters and managing water resources effectively.',
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
                    child: Text('LET\'S GET STARTED!'),
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
