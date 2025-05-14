import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/mechanic_provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/review_provider.dart';
import 'package:car2go_mobile_app/auth/presentation/screen/login.dart';
import 'package:car2go_mobile_app/shared/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MechanicProvider>(context, listen: false).loadVehicles();
    });
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final token = prefs.getString('token');

    if (username != null && token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car2Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: _isLoggedIn ? const MainScreen() : const LoginPage(),
    );
  }
}
