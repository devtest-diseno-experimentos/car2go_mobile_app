import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car2go_mobile_app/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Iniciar sesión
  static Future<Map<String, dynamic>?> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse(Constant.getEndpoint('authentication/sign-in'));

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('username', data['username']);

      return {'token': data['token'], 'username': data['username']};
    } else {
      print("Login error: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> register(
    String username,
    String password,
    List<String> roles,
  ) async {
    final url = Uri.parse(Constant.getEndpoint('authentication/sign-up'));

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "roles": roles,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> createProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String dni,
    required String address,
    required String phone,
    required String image,
  }) async {
    final url = Uri.parse(Constant.getEndpoint('profiles'));

    // Obtener el token almacenado en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ Error: No se encontró un token de autenticación.");
      return false;
    }

    // Cuerpo de la solicitud con paymentMethods hardcodeado
    final body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "dni": dni,
      "address": address,
      "phone": phone,
      "image": image,
      "paymentMethods": [
        {"id": 0, "type": "BBVA", "details": "12345678912345678912"},
      ],
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Agregar el token en los encabezados
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("✅ Perfil creado exitosamente.");
      return true;
    } else {
      print("❌ Error al crear el perfil: ${response.statusCode}");
      print("Detalles: ${response.body}");
      return false;
    }
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // elimina todos los datos guardados
  }

  // Verificar si hay sesión activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
