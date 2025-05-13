import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/mechanic_provider.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/review_history.dart';
import 'package:car2go_mobile_app/mechanic/presentation/screen/vehicle_review.dart';

class TechnicalReviewScreen extends StatefulWidget {
  const TechnicalReviewScreen({super.key});

  @override
  _TechnicalReviewScreenState createState() => _TechnicalReviewScreenState();
}

class _TechnicalReviewScreenState extends State<TechnicalReviewScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MechanicProvider>(context, listen: false).loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final mechanicProvider = Provider.of<MechanicProvider>(context);
    final pendingVehicles = mechanicProvider.pendingVehicles;

    return Scaffold(
      body: Padding(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewHistoryScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2959AD),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 8,
                    ),
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
            Expanded(
              child:
                  pendingVehicles.isEmpty
                      ? const Center(child: Text('No hay autos en espera'))
                      : ListView.builder(
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
                                  child:
                                      vehicle.image.isNotEmpty
                                          ? Image.network(
                                            vehicle.image.first,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 300,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.asset(
                                                'assets/images/car.png',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 300,
                                              );
                                            },
                                          )
                                          : Image.asset(
                                            'assets/images/car.png',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 300,
                                          ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 26,
                                      vertical: 8,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                builder:
                                                    (context) =>
                                                        VehicleReviewScreen(
                                                          vehicleId: vehicle.id,
                                                        ),
                                              ),
                                            );

                                            if (result == true) {
                                              Provider.of<MechanicProvider>(
                                                context,
                                                listen: false,
                                              ).loadVehicles();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFF4C23D,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 26,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }
}
