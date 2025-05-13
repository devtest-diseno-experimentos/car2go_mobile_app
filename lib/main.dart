import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/mechanic_provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/review_provider.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/dashboard.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/technical_review.dart';
import 'package:car2go_mobile_app/seller/presentation/screens/my_cars_screen.dart';
import 'package:car2go_mobile_app/shared/widgets/custom_bottom_nav.dart';
import 'package:car2go_mobile_app/shared/widgets/custom_app_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MechanicProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final int initialIndex;

  const MyApp({super.key, this.initialIndex = 0});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _currentIndex;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  bool get _showBars => true;

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car2Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: _showBars ? const CustomAppBar() : null,
        body: Stack(
          children: List.generate(_navigatorKeys.length, (index) {
            return Offstage(
              offstage: _currentIndex != index,
              child: Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) => _getScreenForIndex(index),
                  );
                },
              ),
            );
          }),
        ),
        bottomNavigationBar:
            _showBars
                ? CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                )
                : null,
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return TechnicalReviewScreen();
      case 2:
        return MyCarsScreen();
      default:
        return DashboardScreen();
    }
  }
}
