import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';

class CarDetailScreen extends StatefulWidget {
  final int vehicleId;

  const CarDetailScreen({super.key, required this.vehicleId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  late Future<Vehicle> _vehicleFuture;
  String? _mainImage;

  @override
  void initState() {
    super.initState();
    _vehicleFuture = VehicleService.fetchVehicleById(widget.vehicleId);
    _vehicleFuture.then((vehicle) {
      setState(() {
        _mainImage = vehicle.image.isNotEmpty ? vehicle.image[0] : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Vehicle>(
          future: _vehicleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Vehículo no encontrado'));
            } else {
              final vehicle = snapshot.data!;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: _buildDetail(vehicle),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'S/ ${vehicle.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2959AD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Mandar oferta',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetail(Vehicle vehicle) {
    Widget displayImage(String? img, {Key? key}) {
      if (img != null && img.startsWith('data:image')) {
        final base64Str = img.split(',').last;
        return Image.memory(
          base64Decode(base64Str),
          key: key,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset('assets/images/car.png', width: double.infinity, height: 200, fit: BoxFit.cover),
        );
      } else if (img != null && img.startsWith('http')) {
        return Image.network(
          img,
          key: key,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset('assets/images/car.png', width: double.infinity, height: 200, fit: BoxFit.cover),
        );
      } else {
        return Image.asset(
          'assets/images/car.png',
          key: key ?? const ValueKey('default_image'),
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${vehicle.brand} ${vehicle.model}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2959AD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Editar carro'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: displayImage(_mainImage, key: ValueKey(_mainImage)),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(vehicle.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusLabel(vehicle.status),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 16),

        if (vehicle.image.isNotEmpty)
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vehicle.image.length,
              itemBuilder: (context, index) {
                final img = vehicle.image[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _mainImage = img;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: displayImage(img),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 24),
        const Text('Descripción general', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),


        LayoutBuilder(builder: (context, constraints) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _SpecIcon(icon: Icons.calendar_today, label: vehicle.year.toString()),
              _SpecIcon(icon: Icons.speed, label: '${vehicle.mileage.toStringAsFixed(0)} km'),
              _SpecIcon(icon: Icons.local_gas_station, label: vehicle.fuel),
              _SpecIcon(icon: Icons.location_on, label: vehicle.location),
              _SpecIcon(icon: Icons.route, label: '${vehicle.speed} km/h'),
              _SpecIcon(icon: Icons.engineering, label: vehicle.engine),
              _SpecIcon(icon: Icons.water_drop, label: vehicle.color),
            ],
          );
        }),

        const SizedBox(height: 24),
        const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          vehicle.description,
          style: const TextStyle(height: 1.4),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.grey;
      case 'REVIEWED':
        return Colors.green;
      case 'REJECT':
        return Colors.red;
      default:
        return Colors.grey[700]!;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'En revisión';
      case 'REVIEWED':
        return 'Revisado';
      case 'REJECT':
        return 'Rechazado';
      default:
        return status;
    }
  }
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final double itemWidth = (MediaQuery.of(context).size.width - 20 * 2 - 12 * 3) / 4;

    return Container(
      width: itemWidth,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4C23D),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
