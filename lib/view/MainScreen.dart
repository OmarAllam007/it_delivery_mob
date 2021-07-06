import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/UserProfile.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/view/NotificationScreen.dart';
import 'package:it_delivery/view/RequestsScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

List screens = [RequestsScreen(), NotificationScreen(), UserProfile()];

class _MainScreenState extends State<MainScreen> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text(T(context, 'Requests')),
            activeColor: Colors.teal.shade600,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text(T(context, 'Notifications')),
            activeColor: Colors.teal.shade600,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(T(context, 'Profile')),
            activeColor: Colors.teal.shade700,
          ),
        ],
      ),
    );
  }
}
