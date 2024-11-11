import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main_app/pages/homepage/pages/stations_map.dart';
import '/pages/homepage/pages/stations_map.dart';
import './pages/app_drawer.dart';
import './pages/authentication/login/login_page.dart';
import './pages/authentication/signup/signup_page.dart';
import './pages/home_page.dart';
import 'pages/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // System UI Configuration
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    return MaterialApp(
      theme: AppTheme.themeData,
      // home: MapScreen(), // Set SplashScreen as the initial route
      // initialRoute:'/home',
      initialRoute:'/splash',
      routes: {
        '/splash': (context) => SplashScreen(),

        '/auth': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),

        '/page1': (context) => Page2(),
        '/page2': (context) => Page2(),
        '/page3': (context) => Page3(),
        '/page4': (context) => Page4(),

        '/AppDrawerpage1': (context) => AppDrawerPage2(),
        '/AppDrawerpage2': (context) => AppDrawerPage2(),
        '/AppDrawerpage3': (context) => AppDrawerPage3(),
        '/AppDrawerpage4': (context) => AppDrawerPage4(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}









//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PageViewScreen(),
//     );
//   }
// }
//
// class PageViewScreen extends StatelessWidget {
//   final PageController _pageController = PageController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: [
//           MapScreen(),
//           CustomerServiceScreen(),
//         ],
//       ),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;
//
//   final LatLng _center = const LatLng(6.9271, 79.8612); // Colombo, Sri Lanka
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onVerticalDragUpdate: (_) {},
//         onHorizontalDragUpdate: (_) {},
//         child: Container(
//           width: double.infinity,
//           height: 400, // Adjust the height as needed
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//             ),
//           ),
//           child: GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _center,
//               zoom: 10.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomerServiceScreen extends StatelessWidget {
//   final List<Map<String, String>> branches = [
//     {
//       "title": "Main Branch",
//       "contact_no": "0112343556",
//       "description": "280, Sample Road, Sample City, 13000"
//     },
//     {
//       "title": "Second Branch",
//       "contact_no": "0112343557",
//       "description": "281, Sample Road, Sample City, 13001"
//     }
//     // Add more branches here as needed
//   ];
//
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     try {
//       if (await canLaunch(launchUri.toString())) {
//         await launch(launchUri.toString());
//       } else {
//         throw 'Could not launch $launchUri';
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Customer Service',
//                   style: TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 28,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16), // Add some spacing between the title and the list
//             Expanded(
//               child: ListView.builder(
//                 itemCount: branches.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(branches[index]['title']!),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(branches[index]['description']!),
//                           SizedBox(height: 8),
//                           TextButton(
//                             onPressed: () {
//                               _makePhoneCall(branches[index]['contact_no']!);
//                             },
//                             child: Text('Call: ${branches[index]['contact_no']}'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }