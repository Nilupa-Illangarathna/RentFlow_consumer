import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServicePage extends StatelessWidget {
  final List<Map<String, String>> branches = [
    {
      "title": "Main Branch",
      "contact_no": "0112343556",
      "description": "280, Sample Road, Sample City, 13000"
    },
    {
      "title": "Main Branch",
      "contact_no": "0112343556",
      "description": "280, Sample Road, Sample City, 13000"
    }
    // Add more branches here as needed
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Color(0xFF2D6A4F), // Adjust the circle color here
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: 13,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Customer Service',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add some spacing between the title and the list
            Expanded(
              child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0), // 8 px gap between cards
                    child: Card(
                      color: Color(0xFFADF2C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    branch['title']!,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      letterSpacing: 0.5,
                                      color: Color(0xFF1D1B20),
                                    ),
                                  ),
                                  Text(
                                    branch['description']!,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                      letterSpacing: 0.25,
                                      color: Color(0xFF49454F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: Icon(Icons.call),
                                color: Colors.black,
                                iconSize: 24,
                                onPressed: () => _makePhoneCall(branch['contact_no']!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
