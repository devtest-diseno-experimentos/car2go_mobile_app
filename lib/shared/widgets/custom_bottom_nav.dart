import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String role;
  final String currentRouteKey;
  final void Function(String routeKey) onNavigate;

  const CustomBottomNavBar({
    super.key,
    required this.role,
    required this.currentRouteKey,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = <Map<String, dynamic>>[];

    if (role == 'ROLE_MECHANIC') {
      destinations.addAll([
        {'icon': Icons.home, 'label': 'Dashboard', 'routeKey': 'dashboard'},
        {'icon': Icons.grid_view_rounded, 'label': 'Review', 'routeKey': 'review'},
      ]);
    } else if (role == 'ROLE_SELLER') {
      destinations.addAll([
        {'icon': Icons.directions_car_filled_outlined, 'label': 'My Cars', 'routeKey': 'myCars'},
        {'icon': Icons.add_circle_outline, 'label': 'Add Car', 'routeKey': 'CarForm'},
      ]);
    }

    final currentIndex = destinations.indexWhere(
          (dest) => dest['routeKey'] == currentRouteKey,
    );

    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFEFF8FF),
      selectedIndex: currentIndex >= 0 ? currentIndex : 0,
      destinations: destinations.map((dest) {
        return NavigationDestination(
          icon: Icon(dest['icon']),
          label: dest['label'],
        );
      }).toList(),
      onDestinationSelected: (index) {
        onNavigate(destinations[index]['routeKey']);
      },
    );
  }
}
