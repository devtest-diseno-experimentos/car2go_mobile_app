import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car2go_mobile_app/shared/constants/constant.dart';
import 'package:car2go_mobile_app/mechanic/data/models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VehicleStatus {
  PENDING,
  REVIEWED,
  REJECT,
  REQUIRES_REPAIR,
  REPAIR_REQUESTED,
  APPROVED_AFTER_REPAIR,
}

class ReviewService {
  static Future<Review> getReviewForVehicle(int vehicleId) async {
    final url = Uri.parse(Constant.getEndpoint('reviews/$vehicleId'));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      return Review.fromJson(decoded);
    } else {
      throw Exception('Error al obtener la revisión: ${response.body}');
    }
  }

  static Future<List<Review>> getReviews() async {
    final url = Uri.parse(Constant.getEndpoint('reviews/me'));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<void> createReview({
    required int vehicleId,
    required String notes,
    required VehicleStatus status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('reviews'));

    String statusString = status.toString().split('.').last;

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "vehicleId": vehicleId,
        "notes": notes,
        "status": statusString,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear la revisión: ${response.body}');
    }
  }

  static Future<void> updateReviewNotes({
    required int reviewId,
    required String notes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('reviews/$reviewId/notes'));

    final response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "text/plain",
      },
      body: notes,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al actualizar las notas de la revisión: ${response.body}');
    }
  }

  static Future<void> updateReviewStatus({
    required int reviewId,
    required VehicleStatus status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('reviews/$reviewId/status'));

    String statusString = status.toString().split('.').last;

    print('Status enviado al backend: "$statusString"');

    final response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "text/plain",
      },
      body: statusString,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Respuesta del servidor: ${response.body}');
      throw Exception('Error al actualizar el estado de la revisión: ${response.body}');
    }

    print('Revisión actualizada con éxito');
  }

}
