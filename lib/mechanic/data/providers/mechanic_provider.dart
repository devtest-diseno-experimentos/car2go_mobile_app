import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/mechanic/data/models/vehicle_model.dart';
import 'package:car2go_mobile_app/mechanic/data/services/vehicle_service.dart';

class MechanicProvider with ChangeNotifier {
  List<Vehicle> _allVehicles = [];
  List<Vehicle> _pendingVehicles = [];
  List<Vehicle> _reviewedVehicles = [];

  List<Vehicle> get pendingVehicles => _pendingVehicles;
  List<Vehicle> get reviewedVehicles => _reviewedVehicles;

  double get pendingPercentage {
    if (_allVehicles.isEmpty) return 0.0;
    return _pendingVehicles.length / _allVehicles.length;
  }

  double get reviewedPercentage {
    if (_allVehicles.isEmpty) return 0.0;
    return _reviewedVehicles.length / _allVehicles.length;
  }

  Future<void> loadVehicles() async {
    try {
      _allVehicles = await VehicleService.fetchAllVehicles();

      _pendingVehicles = _allVehicles.where((v) => v.status == 'PENDING').toList();
      _reviewedVehicles = _allVehicles.where((v) => v.status == 'REVIEWED').toList();

      notifyListeners();
    } catch (e) {
      print('Error cargando vehículos: $e');
    }
  }
}
