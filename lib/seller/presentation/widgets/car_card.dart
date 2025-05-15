import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';

class CarCard extends StatelessWidget {
  final Vehicle vehicle;

  const CarCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final imageUrl = vehicle.image.isNotEmpty ? vehicle.image[0] : null;

    Widget displayImage(String? img) {
      if (img != null && img.startsWith('data:image')) {
        final base64Str = img.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset('assets/images/car.png', width: double.infinity, height: 180, fit: BoxFit.cover),
        );
      } else if (img != null && img.startsWith('http')) {
        return Image.network(
          img,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset('assets/images/car.png', width: double.infinity, height: 180, fit: BoxFit.cover),
        );
      } else {
        return Image.asset(
          'assets/images/car.png',
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        );
      }
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: displayImage(imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'S/ ${vehicle.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  vehicle.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SpecIcon(icon: Icons.calendar_today, label: vehicle.year),
                    _SpecIcon(icon: Icons.speed, label: '${vehicle.mileage.toStringAsFixed(0)} km'),
                    _SpecIcon(icon: Icons.local_gas_station, label: vehicle.fuel),
                    _SpecIcon(icon: Icons.location_on, label: vehicle.location),
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
