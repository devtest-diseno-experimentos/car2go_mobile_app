import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowStoredPreferencesScreen extends StatefulWidget {
  const ShowStoredPreferencesScreen({super.key});

  @override
  _ShowStoredPreferencesScreenState createState() =>
      _ShowStoredPreferencesScreenState();
}

class _ShowStoredPreferencesScreenState
    extends State<ShowStoredPreferencesScreen> {
  String _username = '';
  String _token = '';
  String _role = '';
  int _userId = -1;
  int _profileId = -1;

  @override
  void initState() {
    super.initState();
    _loadStoredPreferences();
  }

  void _loadStoredPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'No username stored';
    final token = prefs.getString('token') ?? 'No token stored';
    final role = prefs.getString('role') ?? 'No role stored';
    final userId = prefs.getInt('userId') ?? -1;
    final profileId = prefs.getInt('profileId') ?? -1;

    setState(() {
      _username = username;
      _token = token;
      _role = role;
      _userId = userId;
      _profileId = profileId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stored Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $_username'),
            const SizedBox(height: 20),
            Text('Token: $_token'),
            const SizedBox(height: 20),
            Text('Role: $_role'),
            const SizedBox(height: 20),
            Text('User ID: $_userId'),
            const SizedBox(height: 20),
            Text('Profile ID: $_profileId'),
          ],
        ),
      ),
    );
  }
}
