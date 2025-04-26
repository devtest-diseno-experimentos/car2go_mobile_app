import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:car2go_mobile_app/shared/constants/constant.dart';
import 'package:car2go_mobile_app/mechanic/data/models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {

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
    required bool approved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(Constant.getEndpoint('reviews'));

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "vehicleId": vehicleId,
        "notes": notes,
        "approved": approved,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear la revisión: ${response.body}');
    }
  }

}
