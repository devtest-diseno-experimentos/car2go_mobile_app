import 'package:flutter/material.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Título + botón editar
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
                    const Text('Darcia Bigster SUV', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2959AD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Editar carro'),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Imagen del carro
            Image.asset(
              'assets/images/img-car.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            // Badge revisado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Revisado', style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 16),

            // Miniaturas (simuladas)
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/img-car.png',
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

            const Text('Descripción general', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),

            // Specs
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: const [
                _SpecIcon(icon: Icons.calendar_today, label: '2023'),
                _SpecIcon(icon: Icons.speed, label: '25,000 km'),
                _SpecIcon(icon: Icons.local_gas_station, label: 'Petroleo'),
                _SpecIcon(icon: Icons.location_on, label: 'Lima'),
                _SpecIcon(icon: Icons.route, label: '20,000 km'),
                _SpecIcon(icon: Icons.engineering, label: 'Revisado'),
                _SpecIcon(icon: Icons.water_drop, label: 'Gasolina'),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Este SUV de aspecto robusto comparte muchos de sus rasgos de diseño con el recién presentado Dacia Duster, '
              'aunque este prototipo se presentó antes que él y se espera que esté disponible con una gama de motores de gasolina e híbridos.',
              style: TextStyle(height: 1.4),
            )
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
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }
}
