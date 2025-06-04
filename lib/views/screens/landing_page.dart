import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/bookmark_page.dart';
import 'package:vocably/views/screens/home_screen/home_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[HomeScreen(), BookmarkPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: AppColors.bottomNavBackground,
        indicatorColor: Colors.transparent,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedHome01,
              color: AppColors.inactiveNavIconColor,
            ), // Replace with your actual icons
            selectedIcon: Icon(
              HugeIcons.strokeRoundedHome01,
              color: AppColors.activeNavIconColor,
            ), // Optional: different icon when selected
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedBookBookmark01,
              color: AppColors.inactiveNavIconColor,
            ), // Replace with your actual icons
            selectedIcon: Icon(
              HugeIcons.strokeRoundedBookBookmark01,
              color: AppColors.activeNavIconColor,
            ), // Optional: different icon when selected
            label: '',
          ),
        ],
      ),
    );
  }
}
