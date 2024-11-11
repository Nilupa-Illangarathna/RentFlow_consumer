import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../global/global_settings.dart';
import '../global/responsiveness.dart';
import '../page_viewer.dart';
import '../utils/theme.dart';
import '../widgets/homepage/profile_widget.dart';
import 'app_drawer.dart';
import 'homepage/pages/edit_profile.dart';
import 'homepage/pages/history.dart';
import 'homepage/pages/dashboard.dart';
import 'homepage/pages/qr_code_page.dart';
import 'homepage/pages/stations_map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent going back
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            DashBoard(),
            HistoryPage(),
            QRCodePage(

            ),
            MapScreen(), //TODO
            EditProfile(
              profileImageUrl: null,
            ),
          ],
        ),
        drawer: globalData.enableDrawer ? AppDrawer() : null,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppTheme.themeData.primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(
                  Icons.home, 0), // Modified to include background container
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  Icons.history, 1), // Modified to include background container
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(FontAwesomeIcons.qrcode,
                  2), // Modified to include background container
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  Icons.map, 3), // Modified to include background container
              label: 'Stations',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  Icons.person, 4), // Modified to include background container
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    bool isSelected = index == _selectedIndex;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF92D5AB) : Colors.transparent,
        borderRadius:
        BorderRadius.circular(16.0), // Adjust border radius as needed
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 22.0, vertical: 6.0), // Adjust padding as needed
      child: Icon(iconData,
          color:
          isSelected ? AppTheme.themeData.primaryColor : Color(0xFF404942)),
    );
  }

  void _onItemTapped(int pageIndex) {
    int currentPageIndex = _pageController.page!.round();
    int difference = (pageIndex - currentPageIndex).abs();
    int transitionTimeInMilisec = difference * globalData.homePageViewTransTime;
    if (!_isAnimating) {
      _isAnimating = true;
      Future.delayed(Duration(milliseconds: transitionTimeInMilisec), () {
        setState(() {
          _selectedIndex = pageIndex;
        });
      });
      _animateToPage(pageIndex, transitionTimeInMilisec);
    }
  }

  void _animateToPage(int pageIndex, int transitionTimeInMilisec) {
    _pageController
        .animateToPage(
      pageIndex,
      duration: Duration(
          milliseconds:
          transitionTimeInMilisec), // Adjust duration for smoother animation
      curve: Curves.easeInOut,
    )
        .then((value) {
      setState(() {
        _isAnimating = false;
      });
    });
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 3'),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 4'),
    );
  }
}
