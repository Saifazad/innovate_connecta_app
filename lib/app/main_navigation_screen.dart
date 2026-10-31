import 'package:flutter/material.dart';
import '../features/dashboard/views/dashboard_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/resources/views/resources_screen.dart';
import '../features/sessions/views/sessions_screen.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';

/// Persistent navigation shell for the Innovate Connecta application.
/// Keeps the footer permanently visible and fixed, smoothly switching tabs
/// without flickers, unmounting, or creating duplicate pushed routes.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  /// Allows any descendant widget to switch the active tab
  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationScreenState>();
    if (state != null) {
      state.setIndex(index);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: index),
        ),
        (route) => false,
      );
    }
  }

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  static const Color darkCanvas = Color(0xFF090D16);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  void setIndex(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index.clamp(0, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          // If not on Home tab, pressing Back switches to Home tab
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: darkCanvas,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(
              showBottomNav: false,
              onTabSelected: setIndex,
            ),
            SessionsScreen(
              showBottomNav: false,
              onTabSelected: setIndex,
            ),
            DashboardScreen(
              showBottomNav: false,
              onTabSelected: setIndex,
            ),
            ResourcesScreen(
              showBottomNav: false,
              onTabSelected: setIndex,
            ),
            ProfileScreen(
              showBottomNav: false,
              onTabSelected: setIndex,
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          selectedIndex: _currentIndex,
          centerLabel: 'Dashboard',
          onItemTapped: setIndex,
        ),
      ),
    );
  }
}

