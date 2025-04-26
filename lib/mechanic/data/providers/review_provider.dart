import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/mechanic/data/models/review_model.dart';
import 'package:car2go_mobile_app/mechanic/data/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  Future<void> loadReviews() async {
    try {
      _reviews = await ReviewService.getReviews();
      notifyListeners();
    } catch (e) {
      print('Error cargando reviews: $e');
    }
  }
}
