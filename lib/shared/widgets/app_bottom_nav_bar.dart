import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized shared bottom navigation bar for the entire app.
/// Features 5 primary destinations: Home, Sessions, Dashboard (center), Resources, and Profile.
class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final String centerLabel;
  final ValueChanged<int>? onItemTapped;

  const AppBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.centerLabel = 'Dashboard',
    this.onItemTapped,
  });

  static const Color navBackground = Color(0xFF080C17);
  static const Color navBorder = Color(0xFF1E293B);
  static const Color inactiveColor = Color(0xFF64748B);
  static const Color activePurple = Color(0xFFA855F7);
  static const Color indigoAccent = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: navBackground,
        border: Border(
          top: BorderSide(color: navBorder, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              label: 'Home',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.videocam_outlined,
              label: 'Sessions',
            ),
            _buildDashboardItem(),
            _buildNavItem(
              index: 3,
              icon: Icons.menu_book_outlined,
              label: 'Resources',
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? activePurple : inactiveColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemTapped?.call(index),
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem() {
    final isSelected = selectedIndex == 2;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemTapped?.call(2),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [activePurple, indigoAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: activePurple.withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              centerLabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activePurple : inactiveColor,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

