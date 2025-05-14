import 'package:flutter/material.dart';
import '../widgets/car_card.dart';
import '../screens/car_detail_screen.dart';

class MyCarsScreen extends StatelessWidget {
  const MyCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Mis carros',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _NavigableCarCard(),
                  _NavigableCarCard(),
                  _NavigableCarCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigableCarCard extends StatelessWidget {
  const _NavigableCarCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CarDetailScreen(),
          ),
        );
      },
      child: const CarCard(),
    );
  }
}
