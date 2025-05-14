import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/review_provider.dart';

class ReviewHistoryScreen extends StatefulWidget {
  final void Function(String)? onNavigate;

  const ReviewHistoryScreen({super.key, this.onNavigate});

  @override
  _ReviewHistoryScreenState createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).loadReviews();
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

                  final statusColor = status == "REJECT"
                      ? Colors.redAccent
                      : status == "REVIEWED"
                      ? Colors.green
                      : Colors.grey;

                  final statusLabel = status == "REJECT"
                      ? "Rechazado"
                      : status == "REVIEWED"
                      ? "Aceptado"
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
                          child: Image.asset(
                            'assets/images/car.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300,
                          ),
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
                                  "${review.vehicle.brand} ${review.vehicle.model}",
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
                                Text(
                                  "Notas: ${review.notes}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
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
