import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:car2go_mobile_app/mechanic/data/providers/mechanic_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    final mechanicProvider = Provider.of<MechanicProvider>(context, listen: false);
    if (!mechanicProvider.hasLoadedVehicles) {
      mechanicProvider.loadVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mechanicProvider = Provider.of<MechanicProvider>(context);

    if (mechanicProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mechanicProvider.pendingVehicles.isEmpty &&
        mechanicProvider.reviewedVehicles.isEmpty) {
      return const Center(child: Text("No hay vehículos disponibles"));
    }

    return RefreshIndicator(
      onRefresh: () => mechanicProvider.loadVehicles(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: Navegar a la lista de autos verificados
              },
              child: _buildCard(
                title: "Autos Verificados",
                percentage: mechanicProvider.reviewedPercentage,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // TODO: Navegar a la lista de autos pendientes
              },
              child: _buildCard(
                title: "Lista de Espera",
                percentage: mechanicProvider.pendingPercentage,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      width: double.infinity,
      height: 340,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 16.0,
            percent: (percentage > 1.0 ? 1.0 : percentage),
            center: Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
