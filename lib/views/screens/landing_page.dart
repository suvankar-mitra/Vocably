import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/views/screens/bookmark_page.dart';
import 'package:vocably/views/screens/game_page.dart';
import 'package:vocably/views/screens/home_screen/home_screen.dart';
import 'package:vocably/views/screens/settings_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[HomeScreen(), BookmarkPage(), SettingsPage(), GamePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),

          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 5,
              blurStyle: BlurStyle.normal,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(HugeIcons.strokeRoundedHome01),
              selectedIcon: Icon(HugeIcons.strokeRoundedHome01),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(HugeIcons.strokeRoundedFloppyDisk),
              selectedIcon: Icon(HugeIcons.strokeRoundedFloppyDisk),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(HugeIcons.strokeRoundedGame),
              selectedIcon: Icon(HugeIcons.strokeRoundedGame),
              label: 'Games',
            ),
            NavigationDestination(
              icon: Icon(HugeIcons.strokeRoundedSettings01),
              selectedIcon: Icon(HugeIcons.strokeRoundedSettings01),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
