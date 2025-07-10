import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../mechanic/data/providers/mechanic_provider.dart';
import '../../../seller/data/services/vehicle_service.dart';
import '../../../shared/screens/main_screen.dart';

class CarFormScreen extends StatefulWidget {
  const CarFormScreen({super.key});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _doorsController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final List<String> _images = [];

  void _saveVehicle() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final brand = _brandController.text.trim();
    final model = _modelController.text.trim();
    final color = _colorController.text.trim();
    final year = _yearController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final transmission = _transmissionController.text.trim();
    final engine = _engineController.text.trim();
    final mileage = double.tryParse(_mileageController.text.trim()) ?? 0.0;
    final doors = _doorsController.text.trim();
    final plate = _plateController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();
    final fuel = _fuelController.text.trim();
    final speed = int.tryParse(_speedController.text.trim()) ?? 0;

    if (_images.isEmpty) {
      _images.add('https://www.example.com/default-image.png');
    }

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        brand.isEmpty ||
        model.isEmpty ||
        color.isEmpty ||
        year.isEmpty ||
        price <= 0 ||
        transmission.isEmpty ||
        engine.isEmpty ||
        mileage <= 0 ||
        doors.isEmpty ||
        plate.isEmpty ||
        location.isEmpty ||
        description.isEmpty ||
        fuel.isEmpty ||
        speed <= 0 ||
        _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos correctamente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await VehicleService.createVehicle(
      name: name,
      phone: phone,
      email: email,
      brand: brand,
      model: model,
      color: color,
      year: year,
      price: price,
      transmission: transmission,
      engine: engine,
      mileage: mileage,
      doors: doors,
      plate: plate,
      location: location,
      description: description,
      images: _images,
      fuel: fuel,
      speed: speed,
    );

    if (success) {
      await Provider.of<MechanicProvider>(context, listen: false).loadVehicles(forceReload: true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehículo creado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear el vehículo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Crear vehículo',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              _buildTextField(_nameController, 'Nombre'),
              _buildTextField(_phoneController, 'Teléfono'),
              _buildTextField(_emailController, 'E-mail'),
              _buildTextField(_brandController, 'Marca'),
              _buildTextField(_modelController, 'Modelo'),
              _buildTextField(_colorController, 'Color'),
              _buildTextField(_yearController, 'Año'),
              _buildTextField(_priceController, 'Precio'),
              _buildTextField(_transmissionController, 'Transmisión'),
              _buildTextField(_engineController, 'Motor'),
              _buildTextField(_mileageController, 'Kilometraje'),
              _buildTextField(_doorsController, 'Puertas'),
              _buildTextField(_plateController, 'Placa'),
              _buildTextField(_locationController, 'Ubicación'),
              _buildTextField(_descriptionController, 'Descripción'),
              _buildTextField(_fuelController, 'Combustible'),
              _buildTextField(_speedController, 'Velocidad máxima'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2959AD),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB2CEFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Volver',
                  style: TextStyle(
                    color: Color(0xFF2959AD),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
