import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../page_viewer.dart'; // Import the page viewer component
import '../global/global_settings.dart';
import 'home_page.dart'; // Import global data

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.themeData.primaryColor,
            ),
            child: Text(
              'App Drawer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              if (ModalRoute.of(context)!.settings.name != '/home') {
                // Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                // Navigator.pop(context); // Close the drawer
              } else {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              }
              // Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text(
              'Page 1',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppDrawerPage1()));
                // Navigator.pop(context); // Close the drawer
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppDrawerPage1()));
              }



              // Navigator.pop(context); // Close the drawer
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppDrawerPage1()));
            },
          ),
          ListTile(
            title: Text(
              'Page 2',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppDrawerPage2()));
                // Navigator.pop(context); // Close the drawer
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppDrawerPage2()));
              }
            },
          ),
          ListTile(
            title: Text(
              'Page 3',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppDrawerPage3()));
                // Navigator.pop(context); // Close the drawer
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppDrawerPage3()));
              }
            },
          ),
          ListTile(
            title: Text(
              'Page 4',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)!.settings.name != '/home') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppDrawerPage4()));
                // Navigator.pop(context); // Close the drawer
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppDrawerPage4()));
              }
            },
          ),
        ],
      ),
    );
  }
}


class AppDrawerPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context); // Pop the current screen when back button is pressed
        return false; // Returning false prevents the default system back button behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('App Drawer Page 1'),
        // ),
        drawer: globalData.enableDrawer ? AppDrawer() : null,
        body: Center(
          child: Text(
            'App Drawer Page 1',
            style: TextStyle(color: Colors.black), // Adjust text color
          ),
        ),
      ),
    );
  }
}

class AppDrawerPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context); // Pop the current screen when back button is pressed
        return false; // Returning false prevents the default system back button behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('App Drawer Page 2'),
        // ),
        drawer: globalData.enableDrawer ? AppDrawer() : null,
        body: Center(
          child: Text(
            'App Drawer Page 2',
            style: TextStyle(color: Colors.black), // Adjust text color
          ),
        ),
      ),
    );
  }
}

class AppDrawerPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context); // Pop the current screen when back button is pressed
        return false; // Returning false prevents the default system back button behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('App Drawer Page 3'),
        // ),
        drawer: globalData.enableDrawer ? AppDrawer() : null,
        body: Center(
          child: Text(
            'App Drawer Page 3',
            style: TextStyle(color: Colors.black), // Adjust text color
          ),
        ),
      ),
    );
  }
}

class AppDrawerPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context); // Pop the current screen when back button is pressed
        return false; // Returning false prevents the default system back button behavior
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('App Drawer Page 4'),
        // ),
        drawer: globalData.enableDrawer ? AppDrawer() : null,
        body: Center(
          child: Text(
            'App Drawer Page 4',
            style: TextStyle(color: Colors.black), // Adjust text color
          ),
        ),
      ),
    );
  }
}
