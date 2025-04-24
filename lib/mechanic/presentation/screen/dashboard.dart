import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard("Autos verificados", 0.25, Colors.redAccent),
          SizedBox(height: 20),
          _buildCard("Lista de espera", 0.79, Colors.green),
        ],
      ),
    );
  }

  Widget _buildCard(String title, double percentage, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
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
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          SizedBox(height: 20),
          CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 16.0,
            percent: percentage,
            center: Text("${(percentage * 100).toInt()}%", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            progressColor: color,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
