import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/shared/widgets/ShowStoredPreferencesScreen.dart';  // Asegúrate de importar tu archivo

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShowStoredPreferencesScreen(),
              ),
            );
          },
          child: const Text('Mostrar Datos Almacenados'),
        ),
      ),
    );
  }
}
