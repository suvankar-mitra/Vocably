import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/bookmark_page.dart';
import 'package:vocably/views/screens/home_screen/home_screen.dart';
import 'package:vocably/views/screens/settings_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[HomeScreen(), BookmarkPage(), SettingsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        indicatorColor: Colors.transparent,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedHome01,
              color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            selectedIcon: Icon(
              HugeIcons.strokeRoundedHome01,
              color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedBookBookmark01,
              color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            selectedIcon: Icon(
              HugeIcons.strokeRoundedBookBookmark01,
              color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedSettings01,
              color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            selectedIcon: Icon(
              HugeIcons.strokeRoundedSettings01,
              color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
