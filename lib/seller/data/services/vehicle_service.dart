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
}
