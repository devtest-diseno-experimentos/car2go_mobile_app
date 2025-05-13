import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car2go_mobile_app/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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
      await prefs.setInt('userId', data['id']);

      return {
        'token': data['token'],
        'username': data['username'],
        'id': data['id'],
      };
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

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      print("❌ Error: No se encontró un token o id de usuario.");
      return false;
    }

    final body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "dni": dni,
      "address": address,
      "phone": phone,
      "image": image,
      "paymentMethods": [
        {"id": userId, "type": "BBVA", "details": "12345678912345678912"},
      ],
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
      print("✅ Perfil creado exitosamente.");
      return true;
    } else {
      print("❌ Error al crear el perfil: ${response.statusCode}");
      print("Detalles: ${response.body}");
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
