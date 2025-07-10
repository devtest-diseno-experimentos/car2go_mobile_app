import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/review_provider.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';

class ReviewHistoryScreen extends StatefulWidget {
  final void Function(String)? onNavigate;

  const ReviewHistoryScreen({super.key, this.onNavigate});

  @override
  _ReviewHistoryScreenState createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  Map<int, String?> vehicleImages = {};

  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).loadReviews();
  }

  Future<void> _loadVehicleImage(int vehicleId) async {
    if (vehicleImages.containsKey(vehicleId)) return;

    try {
      final vehicle = await VehicleService.fetchVehicleById(vehicleId);
      if (mounted) {
        setState(() {
          vehicleImages[vehicleId] = vehicle.image.isNotEmpty ? vehicle.image[0] : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          vehicleImages[vehicleId] = null;
        });
      }
      print("Error al cargar imagen del vehículo: $e");
    }
  }

  void _showFullNotesDialog(BuildContext context, String notes, String vehicleInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Notas detalladas - $vehicleInfo'),
          content: SingleChildScrollView(
            child: Text(
              notes,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget displayImage(String? img) {
    if (img != null && img.startsWith('data:image')) {
      final base64Str = img.split(',').last;
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Image.memory(
            base64Decode(base64Str),
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/images/car.png', width: double.infinity, height: 300, fit: BoxFit.cover),
          ),
        ],
      );
    } else if (img != null && img.startsWith('http')) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Image.network(
            img,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox();
            },
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/images/car.png', width: double.infinity, height: 300, fit: BoxFit.cover),
          ),
        ],
      );
    } else {
      return Image.asset(
        'assets/images/car.png',
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final reviews = reviewProvider.reviews;

    final sortedReviews = [...reviews]..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => widget.onNavigate?.call('review'),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Historial de revisiones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: sortedReviews.isEmpty
                  ? const Center(child: Text('No hay revisiones realizadas aún'))
                  : ListView.builder(
                itemCount: sortedReviews.length,
                itemBuilder: (context, index) {
                  final review = sortedReviews[index];
                  final formattedDate = DateFormat('dd/MM/yyyy').format(review.reviewDate);
                  final status = review.vehicle.status;
                  final vehicleInfo = "${review.vehicle.brand} ${review.vehicle.model}";

                  if (!vehicleImages.containsKey(review.vehicle.id)) {
                    _loadVehicleImage(review.vehicle.id);
                  }

                  final imageUrl = vehicleImages[review.vehicle.id];

                  final bool hasLongNotes = review.notes.length > 50;
                  final String displayedNotes = hasLongNotes
                      ? '${review.notes.substring(0, 50)}...'
                      : review.notes;

                  final statusColor = status == "REJECT"
                      ? Colors.redAccent
                      : status == "REVIEWED"
                      ? Colors.green
                      : status == "PENDING"
                      ? Colors.amber
                      : status == "REQUIRES_REPAIR"
                      ? Colors.orange
                      : status == "REPAIR_REQUESTED"
                      ? Colors.blue
                      : status == "APPROVED_AFTER_REPAIR"
                      ? Colors.teal
                      : Colors.grey;

                  final statusLabel = status == "REJECT"
                      ? "Rechazado"
                      : status == "REVIEWED"
                      ? "Aceptado"
                      : status == "PENDING"
                      ? "Pendiente"
                      : status == "REQUIRES_REPAIR"
                      ? "Requiere Reparación"
                      : status == "REPAIR_REQUESTED"
                      ? "Reparación Solicitada"
                      : status == "APPROVED_AFTER_REPAIR"
                      ? "Aceptado después de Reparación"
                      : "Desconocido";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: displayImage(imageUrl),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  vehicleInfo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Fecha: $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Notas: $displayedNotes",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (hasLongNotes)
                                      TextButton(
                                        onPressed: () => _showFullNotesDialog(
                                            context,
                                            review.notes,
                                            vehicleInfo
                                        ),
                                        child: const Text(
                                          "Ver más",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}