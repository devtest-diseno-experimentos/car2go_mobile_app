import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/mechanic/data/services/review_service.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';

class VehicleReviewScreen extends StatefulWidget {
  final int vehicleId;

  const VehicleReviewScreen({super.key, required this.vehicleId});

  @override
  _VehicleReviewScreenState createState() => _VehicleReviewScreenState();
}

class _VehicleReviewScreenState extends State<VehicleReviewScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool? _approved;
  Vehicle? _vehicle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicle();
  }

  Future<void> _fetchVehicle() async {
    try {
      final vehicle = await VehicleService.fetchVehicleById(widget.vehicleId);
      setState(() {
        _vehicle = vehicle;
        _loading = false;
      });
    } catch (e) {
      print('Error cargando vehículo: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _vehicle == null
            ? const Center(child: Text('Error cargando vehículo'))
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_vehicle!.brand} ${_vehicle!.model}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/car.png',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _vehicle!.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/car.png',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  const SizedBox(height: 24),
                  const Text('Descripción general', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _SpecIcon(icon: Icons.calendar_today, label: _vehicle!.year),
                      _SpecIcon(icon: Icons.speed, label: '${_vehicle!.mileage.toStringAsFixed(0)} km'),
                      _SpecIcon(icon: Icons.local_gas_station, label: _vehicle!.fuel),
                      _SpecIcon(icon: Icons.location_on, label: _vehicle!.location),
                      _SpecIcon(icon: Icons.route, label: '${_vehicle!.speed} km/h'),
                      _SpecIcon(icon: Icons.engineering, label: _vehicle!.engine),
                      _SpecIcon(icon: Icons.water_drop, label: _vehicle!.color),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Descripción', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    _vehicle!.description,
                    style: const TextStyle(height: 1.4),
                  ),

                  const SizedBox(height: 24),
                  const Text('Notas de la Revisión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Escribe tus observaciones...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('Resultado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<bool>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    value: _approved,
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Aceptar')),
                      DropdownMenuItem(value: false, child: Text('Rechazar')),
                    ],
                    onChanged: (value) => setState(() => _approved = value),
                    hint: const Text('Selecciona una opción'),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2959AD),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Enviar Revisión', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_notesController.text.isEmpty || _approved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      await ReviewService.createReview(
        vehicleId: widget.vehicleId,
        notes: _notesController.text,
        approved: _approved!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Revisión enviada correctamente'), backgroundColor: Colors.green),
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al enviar revisión: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 18,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF4C23D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
