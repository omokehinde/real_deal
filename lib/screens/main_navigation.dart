import 'package:flutter/material.dart';
import 'package:real_deal/screens/home_screen.dart';
import 'package:real_deal/screens/search_screen.dart';
import 'package:real_deal/widgets/navigation/bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const SearchScreen(),
    const Scaffold(body: Center(child: Text('Messages'))), 
    const HomeScreen(),
    const Scaffold(body: Center(child: Text('Saved'))), 
    const Scaffold(body: Center(child: Text('Profile'))), 
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _screens[_currentIndex],
          
          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavigationTap,
            ),
          ),
        ],
      ),
    );
  }
}
