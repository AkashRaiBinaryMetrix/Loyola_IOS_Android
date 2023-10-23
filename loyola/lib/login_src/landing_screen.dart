import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:loyola/src/notification_screen.dart';
import 'package:loyola/src/profile_screen.dart';
import 'package:loyola/src/survey_history_screen.dart';
import 'package:loyola/src/survey_screen.dart';
import '../Commons/constant_class.dart';
import '../src/home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  final List _screen = [
    const HomeScreen(),
    const SurveyScreen(),
    const SurveyHistoryScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];
  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      // icon: Icon(Icons.home_outlined),
      icon: ImageIcon(
        AssetImage("assets/images/home_icon.png"),
      ),
      label: '',
    ),
    const BottomNavigationBarItem(
      // icon: Icon(Icons.calendar_today_outlined),
      icon: ImageIcon(
        AssetImage("assets/images/complete.png"),
      ),
      label: '',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage("assets/images/user_icon.png"),
      ),
      label: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) {
          _onItemTapped(val);
        },
        currentIndex: _selectedIndex,
        backgroundColor: CustomColor.buttonColor,
        selectedItemColor: CustomColor.buttonColor,
        items: [
          FloatingNavbarItem(icon: Icons.home_outlined),
          FloatingNavbarItem(icon: Icons.sticky_note_2_outlined),
          FloatingNavbarItem(icon: Icons.access_time),
          FloatingNavbarItem(icon: Icons.notifications_none_outlined),
          FloatingNavbarItem(icon: Icons.perm_identity_rounded),

          // FloatingNavbarItem(icon: Icons.home),
          // FloatingNavbarItem(icon: Icons.sticky_note_2_outlined),
          // FloatingNavbarItem(icon: Icons.access_time),
          // FloatingNavbarItem(icon: Icons.notifications_none_outlined),
          // FloatingNavbarItem(icon: Icons.perm_identity_rounded),
        ],
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: CustomColor.buttonColor,
      //       border: Border.all(color: Colors.white),
      //       borderRadius: const BorderRadius.only(
      //           topLeft: Radius.circular(12.0),
      //           topRight: Radius.circular(12.0),
      //           bottomLeft: Radius.circular(12.0),
      //           bottomRight: Radius.circular(12.0)),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.05),
      //           spreadRadius: 1,
      //           blurRadius: 1,
      //           offset: const Offset(0, 1), // changes position of shadow
      //         ),
      //       ],
      //     ),
      //
      //     child: BottomNavigationBar(
      //       elevation: 10,
      //       backgroundColor: CustomColor.buttonColor,
      //       type: BottomNavigationBarType.fixed,
      //       items: _navItems,
      //
      //       // const <BottomNavigationBarItem>[],
      //       currentIndex: _selectedIndex,
      //       selectedItemColor: Colors.white,
      //       unselectedItemColor: Colors.black54,
      //       showSelectedLabels: true,
      //       onTap: _onItemTapped,
      //
      //     ),
      //   ),
      // ),
    );
  }
}
