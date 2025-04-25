import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'assets/images/img-car.png',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modelo Auto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Precio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Massa quis eget sollicitudin sit elit sollicitudin imperdiet felis elit.',
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SpecIcon(icon: Icons.calendar_today, label: '2023'),
                    _SpecIcon(icon: Icons.speed, label: '25,000 km'),
                    _SpecIcon(icon: Icons.local_gas_station, label: 'Petroleo'),
                    _SpecIcon(icon: Icons.location_on, label: 'Lima'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
