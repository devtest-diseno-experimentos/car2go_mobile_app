import 'package:flutter/material.dart';
import '../../../shared/screens/main_screen.dart';

class CarFormScreen extends StatelessWidget {
  const CarFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            const Text(
              'Formulario de venta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Datos de contacto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _LabelledText(
              label: 'Nombre',
              value: 'Paola Del Rosario Abanto Sanchez',
            ),
            const _LabelledText(
              label: 'Correo',
              value: 'haxek16906@ploncy.com',
            ),
            _buildTextField(label: 'Celular'),
            _buildTextField(label: 'Precio'),
            const SizedBox(height: 20),
            const Text(
              'Datos de carro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextField(label: 'Marca'),
            _buildTextField(label: 'Modelo'),
            _buildTextField(label: 'Color'),
            _buildTextField(label: 'Año de fabricación'),
            _buildTextField(label: 'Tipo de transmisión'),
            _buildTextField(label: 'Motor (cilindrada)'),
            _buildTextField(label: 'Kilometraje'),
            _buildTextField(label: 'Tipo de combustible'),
            _buildTextField(label: 'Velocidad máxima'),
            _buildTextField(label: 'Número de puertas'),
            _buildTextField(label: 'Placa'),
            _buildTextField(label: 'Ubicación'),
            _buildTextField(label: 'Descripción', maxLines: 4),
            const SizedBox(height: 16),
            const Text('Fotos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Subir fotos'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFC107),
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Carro publicado exitosamente!')),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                });
              },
              child: const Text('Publicar carro'),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(label),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: const InputDecoration(
            hintText: 'Placeholder',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _LabelledText extends StatelessWidget {
  final String label;
  final String value;

  const _LabelledText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
