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

  @override
  void initState() {
    super.initState();
    _vehicleFuture = VehicleService.fetchVehicleById(widget.vehicleId);
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
                              'S/ ${vehicle.price.toStringAsFixed(2)}', // Usando el precio del vehículo
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
                            onPressed: () {}, // Sin funcionalidad, pero visualmente habilitado
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2959AD), // Azul exacto
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0, // Sin sombra
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
    final imageUrl = vehicle.image.isNotEmpty ? vehicle.image[0] : null;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Acción editar
              },
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
          child: imageUrl != null
              ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/car.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  'assets/images/car.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 10),
        if (vehicle.status.toLowerCase() == 'revisado')
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Revisado', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        const SizedBox(height: 16),
        // Usamos Wrap para los íconos, con tamaño fijo para cada ícono
        Wrap(
          spacing: 12, // Espacio entre los íconos
          runSpacing: 12, // Espacio entre filas
          alignment: WrapAlignment.center, // Centrar los íconos
          children: [
            _SpecIcon(icon: Icons.calendar_today, label: vehicle.year.toString()),
            _SpecIcon(icon: Icons.speed, label: '${vehicle.mileage.toStringAsFixed(0)} km'),
            _SpecIcon(icon: Icons.local_gas_station, label: vehicle.fuel),
            _SpecIcon(icon: Icons.location_on, label: vehicle.location),
            _SpecIcon(icon: Icons.route, label: '${vehicle.speed} km/h'),
            _SpecIcon(icon: Icons.engineering, label: vehicle.engine),
            _SpecIcon(icon: Icons.water_drop, label: vehicle.color),
          ],
        ),
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
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Ancho fijo
      height: 100, // Alto fijo
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // Centrar los íconos y texto
        children: [
          Icon(icon, size: 30, color: Colors.black), // Ícono más grande para visibilidad
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }
}
