import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/mechanic/data/services/review_service.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';
import 'package:car2go_mobile_app/mechanic/data/models/review_model.dart';

class VehicleReviewScreen extends StatefulWidget {
  final int vehicleId;

  const VehicleReviewScreen({super.key, required this.vehicleId});

  @override
  _VehicleReviewScreenState createState() => _VehicleReviewScreenState();
}

class _VehicleReviewScreenState extends State<VehicleReviewScreen> {
  final TextEditingController _notesController = TextEditingController();
  VehicleStatus? _selectedStatus;
  Vehicle? _vehicle;
  bool _loading = true;
  Review? _existingReview;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchVehicle();
  }

  Widget displayImage(String? img) {
    if (img != null && img.startsWith('data:image')) {
      final base64Str = img.split(',').last;
      return Image.memory(
        base64Decode(base64Str),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/car.png', width: double.infinity, height: 200, fit: BoxFit.cover),
      );
    } else if (img != null && img.startsWith('http')) {
      return Image.network(
        img,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/car.png', width: double.infinity, height: 200, fit: BoxFit.cover),
      );
    } else {
      return Image.asset(
        'assets/images/car.png',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pendiente';
      case 'REPAIR_REQUESTED':
        return 'Requiere Reparación';
      case 'REVIEWED':
        return 'Revisado';
      case 'REJECT':
        return 'Rechazado';
      case 'APPROVED_AFTER_REPAIR':
        return 'Aprobado después de reparación';
      default:
        return status;
    }
  }

  Widget displayThumbnail(String? img, int index) {
    Widget thumbnail;

    if (img != null && img.startsWith('data:image')) {
      final base64Str = img.split(',').last;
      thumbnail = Image.memory(
        base64Decode(base64Str),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/car.png', width: 70, height: 70, fit: BoxFit.cover),
      );
    } else if (img != null && img.startsWith('http')) {
      thumbnail = Image.network(
        img,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/car.png', width: 70, height: 70, fit: BoxFit.cover),
      );
    } else {
      thumbnail = Image.asset(
        'assets/images/car.png',
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImageIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedImageIndex == index ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: thumbnail,
        ),
      ),
    );
  }

  Future<void> _fetchVehicle() async {
    try {
      final vehicle = await VehicleService.fetchVehicleById(widget.vehicleId);
      setState(() {
        _vehicle = vehicle;
        _loading = false;
        _selectedStatus = _getInitialStatus(vehicle.status);
      });

      if (_vehicle!.status == 'REPAIR_REQUESTED') {
        _fetchReviewForVehicle();
      }
    } catch (e) {
      print('Error cargando vehículo: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchReviewForVehicle() async {
    try {
      final review = await ReviewService.getReviewForVehicle(widget.vehicleId);
      setState(() {
        _existingReview = review;
        _notesController.text = _existingReview?.notes ?? '';
      });
    } catch (e) {
      print('Error obteniendo la revisión: $e');
    }
  }

  VehicleStatus? _getInitialStatus(String currentStatus) {
    switch (currentStatus) {
      case 'PENDING':
        return VehicleStatus.REVIEWED;
      case 'REPAIR_REQUESTED':
        return VehicleStatus.APPROVED_AFTER_REPAIR;
      default:
        return null;
    }
  }

  List<DropdownMenuItem<VehicleStatus>> _getStatusOptions() {
    if (_vehicle?.status == 'PENDING') {
      return [
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REVIEWED,
          child: Text('Aceptar'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REJECT,
          child: Text('Rechazar'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REQUIRES_REPAIR,
          child: Text('Requiere Reparación'),
        ),
      ];
    }
    // Si el vehículo está en estado REPAIR_REQUESTED
    else if (_vehicle?.status == 'REPAIR_REQUESTED') {
      return [
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.APPROVED_AFTER_REPAIR,
          child: Text('Aceptar'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REJECT,
          child: Text('Rechazar'),
        ),
      ];
    }
    else {
      return [
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REVIEWED,
          child: Text('Aceptar'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REJECT,
          child: Text('Rechazar'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.REQUIRES_REPAIR,
          child: Text('Requiere Reparación'),
        ),
        DropdownMenuItem<VehicleStatus>(
          value: VehicleStatus.APPROVED_AFTER_REPAIR,
          child: Text('Aceptar Reparación'),
        ),
      ];
    }
  }

  Future<void> _submitReview() async {
    if (_notesController.text.isEmpty || _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      if (_vehicle!.status == 'REPAIR_REQUESTED' && _existingReview != null) {
        await ReviewService.updateReviewNotes(
          reviewId: _existingReview!.id,
          notes: _notesController.text,
        );

        await ReviewService.updateReviewStatus(
          reviewId: _existingReview!.id,
          status: VehicleStatus.values.firstWhere(
                  (e) => e.toString().split('.').last == _selectedStatus.toString().split('.').last
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisión actualizada'), backgroundColor: Colors.green),
        );
      } else {
        await ReviewService.createReview(
          vehicleId: widget.vehicleId,
          notes: _notesController.text,
          status: _selectedStatus!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revisión creada'), backgroundColor: Colors.green),
        );
      }

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar revisión: $e'), backgroundColor: Colors.red),
      );
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
                    child: _vehicle!.image.isNotEmpty
                        ? displayImage(_vehicle!.image[_selectedImageIndex])
                        : displayImage(null),
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
                        _getStatusLabel(_vehicle!.status),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _vehicle!.image.length > 1 ? SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _vehicle!.image.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: displayThumbnail(_vehicle!.image[index], index),
                        );
                      },
                    ),
                  ) : const SizedBox(),
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
                  Text(_vehicle!.description, style: const TextStyle(height: 1.4)),
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
                  DropdownButtonFormField<VehicleStatus>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    value: _selectedStatus,
                    items: _getStatusOptions(),
                    onChanged: (value) => setState(() {
                      _selectedStatus = value;
                    }),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
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