import 'dart:convert';
import 'package:car2go_mobile_app/shared/constants/constant.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleService {
  static Future<List<Vehicle>> fetchAllVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('vehicle/all'));
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();
    } else {
      print('Error al obtener vehículos: ${response.body}');
      throw Exception('Fallo al cargar vehículos');
    }
  }

  static Future<Vehicle> fetchVehicleById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('vehicle/$id'));
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Vehicle.fromJson(data);
    } else {
      print('Error al obtener vehículo por ID: ${response.body}');
      throw Exception('Fallo al cargar vehículo');
    }
  }

  static Future<List<Vehicle>> fetchVehiclesByProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final profileId = prefs.getInt('profileId');

    if (profileId == null) {
      throw Exception('No se encontró profileId en las preferencias');
    }

    final url = Uri.parse(Constant.getEndpoint('vehicle/all/vehicles/profile/$profileId'));
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();
    } else {
      print('Error al obtener vehículos por profileId: ${response.body}');
      throw Exception('Fallo al cargar vehículos por profileId');
    }
  }

  static Future<bool> createVehicle({
    required String name,
    required String phone,
    required String email,
    required String brand,
    required String model,
    required String color,
    required String year,
    required double price,
    required String transmission,
    required String engine,
    required double mileage,
    required String doors,
    required String plate,
    required String location,
    required String description,
    required List<String> images,
    required String fuel,
    required int speed,
  }) async {
    final url = Uri.parse(Constant.getEndpoint('vehicle'));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      return false;
    }

    final body = jsonEncode({
      "name": name,
      "phone": phone,
      "email": email,
      "brand": brand,
      "model": model,
      "color": color,
      "year": year,
      "price": price,
      "transmission": transmission,
      "engine": engine,
      "mileage": mileage,
      "doors": doors,
      "plate": plate,
      "location": location,
      "description": description,
      "images": images,
      "fuel": fuel,
      "speed": speed,
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Vehículo creado exitosamente.");
      return true;
    } else {
      print("Error al crear el vehículo: ${response.statusCode}");
      print("Detalles: ${response.body}");
      return false;
    }
  }
}
