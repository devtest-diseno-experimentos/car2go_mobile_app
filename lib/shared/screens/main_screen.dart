import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/dashboard.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/technical_review.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/review_history.dart';
import 'package:car2go_mobile_app/seller/presentation/screens/my_cars_screen.dart';
import 'package:car2go_mobile_app/seller/presentation/screens/car_form_screen.dart';
import 'package:car2go_mobile_app/shared/widgets/custom_bottom_nav.dart';
import 'package:car2go_mobile_app/shared/widgets/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _role = '';
  String _currentRouteKey = 'dashboard';

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    setState(() {
      _role = role;
      _currentRouteKey = role == 'ROLE_SELLER' ? 'myCars' : 'dashboard';
    });
  }

  Widget _getScreenForRoute(String routeKey) {
    switch (routeKey) {
      case 'dashboard':
        return const DashboardScreen();
      case 'review':
        return TechnicalReviewScreen(onNavigate: _handleNavigation);
      case 'myCars':
        return const MyCarsScreen();
      case 'CarForm':
        return const CarFormScreen();
      case 'history':
        return ReviewHistoryScreen(onNavigate: _handleNavigation);
      default:
        return const DashboardScreen();
    }
  }

  void _handleNavigation(String routeKey) {
    setState(() {
      if (routeKey == 'history') {
        _currentRouteKey = 'history';
      } else {
        _currentRouteKey = routeKey;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _role.isNotEmpty
          ? _getScreenForRoute(_currentRouteKey)
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _role.isNotEmpty
          ? CustomBottomNavBar(
        role: _role,
        currentRouteKey: _currentRouteKey,
        onNavigate: _handleNavigation,
      )
          : const SizedBox.shrink(),
    );
  }
}
