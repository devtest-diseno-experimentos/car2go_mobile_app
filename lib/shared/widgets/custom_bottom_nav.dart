import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({ super.key, required this.currentIndex, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        onDestinationSelected: onTap,
        selectedIndex: currentIndex,
        indicatorColor: const Color(0xFFEFF8FF),
        backgroundColor: Colors.white,
        destinations: [
          NavigationDestination(
            icon: _buildCustomIcon(Icons.home, currentIndex == 0),
            label: "",
          ),
          NavigationDestination(
            icon: _buildCustomIcon(Icons.grid_view_rounded, currentIndex == 1),
            label: "",
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFF2959AD) : Colors.black,
      ),
    );
  }
}
