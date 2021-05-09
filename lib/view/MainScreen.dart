import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/view/RequestsScreen.dart';
import 'package:it_delivery/view/SelectService.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RequestsScreen(),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          // _pageController.animateToPage(index,
          //     duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Requests'),
            activeColor: Colors.teal.shade600,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text('Users'),
            activeColor: Colors.teal.shade700,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
            activeColor: Colors.teal.shade600,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Profile'),
            activeColor: Colors.teal.shade700,
          ),
        ],
      ),
    );
  }
}
