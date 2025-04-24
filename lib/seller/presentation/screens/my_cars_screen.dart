import 'package:flutter/material.dart';

class MyCarsScreen extends StatelessWidget {
  const MyCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Carros'),
      ),
      body: const Center(
        child: Text('Lista de autos aquí'),
      ),
    );
  }
}
