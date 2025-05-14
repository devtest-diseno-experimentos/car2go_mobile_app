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

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        final userId = data['id'];
        final token = data['token'];
        final user = data['username'];

        await prefs.setString('token', token);
        await prefs.setString('username', user);
        await prefs.setInt('userId', userId);

        final roleResponse = await http.get(
          Uri.parse(Constant.getEndpoint('users/$userId')),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

        if (roleResponse.statusCode == 200) {
          final roleData = jsonDecode(roleResponse.body);
          final roles = roleData['roles'];
          if (roles != null && roles.isNotEmpty) {
            await prefs.setString('role', roles[0]);
          }
        }

        final profileResponse = await http.get(
          Uri.parse(Constant.getEndpoint('profiles/me')),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );

        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body);

          await prefs.setInt('profileId', profileData['profileId']);

        } else {
          print("❌ Error al obtener el perfil: ${profileResponse.statusCode}");
        }

        return {
          'token': token,
          'username': user,
          'id': userId,
        };
      } else {
        print("Login error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error en login: $e");
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
