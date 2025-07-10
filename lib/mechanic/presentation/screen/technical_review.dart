import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/mechanic_provider.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/vehicle_review.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/review_history.dart';
import '../../../seller/data/models/vehicle_model.dart';

class TechnicalReviewScreen extends StatefulWidget {
  final void Function(String routeKey)? onNavigate;

  const TechnicalReviewScreen({super.key, this.onNavigate});

  @override
  State<TechnicalReviewScreen> createState() => _TechnicalReviewScreenState();
}

class _TechnicalReviewScreenState extends State<TechnicalReviewScreen> {
  bool isHistoryView = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MechanicProvider>(context, listen: false).loadVehicles();
  }

  void _goToHistory() {
    setState(() {
      isHistoryView = true;
    });
  }

  void _goToReview() {
    setState(() {
      isHistoryView = false;
    });
  }

  // Método para refrescar la vista al hacer pull-to-refresh
  Future<void> _refreshVehicles() async {
    await Provider.of<MechanicProvider>(context, listen: false).loadVehicles(forceReload: true);
  }

  Widget displayImage(Vehicle vehicle, {double height = 300}) {
    final hasImage = vehicle.image != null && vehicle.image.isNotEmpty;
    final imageUrl = hasImage ? vehicle.image.first : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/car.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      );
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Str = imageUrl.split(',').last;
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: height,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Image.memory(
              base64Decode(base64Str),
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/car.png', width: double.infinity, height: height, fit: BoxFit.cover),
            ),
          ],
        );
      } catch (e) {
        return Image.asset(
          'assets/images/car.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: height,
        );
      }
    } else if (imageUrl.startsWith('http')) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: height,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(); // Invisible while loading
            },
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/car.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: height,
            ),
          ),
        ],
      );
    } else {
      return Image.asset(
        'assets/images/car.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isHistoryView
          ? ReviewHistoryScreen(
        onNavigate: (routeKey) {
          if (routeKey == 'review') {
            _goToReview();
          }
        },
      )
          : Consumer<MechanicProvider>(
        builder: (context, mechanicProvider, child) {
          final pendingVehicles = mechanicProvider.pendingVehicles;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Revisión técnica',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _goToHistory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2959AD),
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Historial',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Agregar RefreshIndicator aquí
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshVehicles, // Llamamos al método para refrescar los vehículos
                    child: pendingVehicles.isEmpty
                        ? const Center(child: Text('No hay autos en espera'))
                        : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: pendingVehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = pendingVehicles[index];

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
                                child: displayImage(vehicle),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${vehicle.brand} ${vehicle.model}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => VehicleReviewScreen(vehicleId: vehicle.id),
                                            ),
                                          );

                                          // Aquí recargamos los vehículos después de la actualización
                                          if (result == true && mounted) {
                                            await Provider.of<MechanicProvider>(
                                              context,
                                              listen: false,
                                            ).loadVehicles(forceReload: true); // Forzar la recarga de vehículos
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF4C23D),
                                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Verificar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
