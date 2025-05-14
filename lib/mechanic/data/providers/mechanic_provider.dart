import 'package:flutter/material.dart';
import 'package:car2go_mobile_app/seller/data/models/vehicle_model.dart';
import 'package:car2go_mobile_app/seller/data/services/vehicle_service.dart';

class MechanicProvider with ChangeNotifier {
  bool hasLoadedVehicles = false;

  List<Vehicle> _allVehicles = [];
  List<Vehicle> _pendingVehicles = [];
  List<Vehicle> _reviewedVehicles = [];

  bool isLoading = true;

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

  Future<void> loadVehicles({bool forceReload = false}) async {
    if (hasLoadedVehicles && !forceReload) return;

    isLoading = true;
    notifyListeners();

    try {
      _allVehicles = await VehicleService.fetchAllVehicles();
      _pendingVehicles =
          _allVehicles.where((v) => v.status == 'PENDING').toList();
      _reviewedVehicles =
          _allVehicles.where((v) => v.status == 'REVIEWED').toList();
      hasLoadedVehicles = true;
    } catch (e) {
      print('Error cargando vehículos: $e');
      _allVehicles = [];
      _pendingVehicles = [];
      _reviewedVehicles = [];
    }

    isLoading = false;
    notifyListeners();
  }

}
