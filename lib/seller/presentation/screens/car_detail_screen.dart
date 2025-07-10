import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';
import 'package:car2go_mobile_app/mechanic/data/services/review_service.dart';
import 'package:car2go_mobile_app/mechanic/data/models/review_model.dart';
import 'package:intl/intl.dart';

class CarDetailScreen extends StatefulWidget {
  final int vehicleId;

  const CarDetailScreen({super.key, required this.vehicleId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  late Future<Vehicle> _vehicleFuture;
  Future<Review>? _reviewFuture;
  String? _mainImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    _vehicleFuture = VehicleService.fetchVehicleById(widget.vehicleId);
    _vehicleFuture.then((vehicle) {
      setState(() {
        _mainImage = vehicle.image.isNotEmpty ? vehicle.image[0] : null;

        // Solo cargar la revisión si el vehículo ha sido revisado
        if (vehicle.status == 'REVIEWED' ||
            vehicle.status == 'REJECT' ||
            vehicle.status == 'REQUIRES_REPAIR' ||
            vehicle.status == 'REPAIR_REQUESTED' ||
            vehicle.status == 'APPROVED_AFTER_REPAIR') {
          _reviewFuture = ReviewService.getReviewForVehicle(widget.vehicleId);
        }
      });
    });
  }

  Future<void> _requestRepair(int reviewId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ReviewService.updateReviewStatus(
          reviewId: reviewId,
          status: VehicleStatus.REPAIR_REQUESTED
      );

      // Recargar los datos del vehículo para reflejar el cambio de estado
      await _loadVehicleData();  // Recarga los datos del vehículo

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud de reparación enviada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al solicitar reparación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rejectRepair(int reviewId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ReviewService.updateReviewStatus(
          reviewId: reviewId,
          status: VehicleStatus.REJECT
      );

      // Recargar los datos del vehículo para reflejar el cambio de estado
      await _loadVehicleData();  // Recarga los datos del vehículo

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reparación rechazada correctamente'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar la reparación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para mostrar diálogo de confirmación
  void _showConfirmationDialog(int reviewId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirmar rechazo'),
          content: const Text('¿Estás seguro de que deseas rechazar la reparación?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _rejectRepair(reviewId);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDetailsModal(Review review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final formattedDate = review.reviewDate != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(review.reviewDate!)
            : 'Fecha no disponible';

        return Container(
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalles de revisión técnica',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              _DetailItem(
                icon: Icons.calendar_month,
                title: 'Fecha de revisión',
                content: formattedDate,
              ),
              const SizedBox(height: 16),

              // Notas del técnico
              const Text(
                'Notas del técnico:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      review.notes ?? 'No hay notas disponibles',
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  if (_isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: CircularProgressIndicator(),
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

        if (_reviewFuture != null) ...[
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informe de revisión técnica',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              FutureBuilder<Review>(
                future: _reviewFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _showReviewDetailsModal(snapshot.data!),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Ver detalles'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2959AD),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<Review>(
            future: _reviewFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar la información de revisión: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No hay información de revisión disponible');
              } else {
                final review = snapshot.data!;

                // Botón para solicitar reparación
                if (vehicle.status.toUpperCase() == 'REQUIRES_REPAIR') {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _requestRepair(review.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4C23D),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Solicitar reparación',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                else if (vehicle.status.toUpperCase() == 'REPAIR_REQUESTED') {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showConfirmationDialog(review.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Rechazar reparación',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }
            },
          ),
        ],
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
      case 'REQUIRES_REPAIR':
        return Colors.orange;
      case 'REPAIR_REQUESTED':
        return Colors.blue;
      case 'APPROVED_AFTER_REPAIR':
        return Colors.green.shade700;
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
      case 'REQUIRES_REPAIR':
        return 'Requiere reparación';
      case 'REPAIR_REQUESTED':
        return 'Reparación solicitada';
      case 'APPROVED_AFTER_REPAIR':
        return 'Aprobado después de reparación';
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

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2959AD)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}