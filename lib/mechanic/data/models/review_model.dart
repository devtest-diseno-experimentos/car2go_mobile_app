class Review {
  final int id;
  final String reviewedBy;
  final String notes;
  final DateTime reviewDate;
  final Vehicles vehicle;

  Review({
    required this.id,
    required this.reviewedBy,
    required this.notes,
    required this.reviewDate,
    required this.vehicle,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      reviewedBy: json['reviewedBy'],
      notes: json['notes'],
      reviewDate: DateTime.parse(json['reviewDate']),
      vehicle: Vehicles.fromJson(json['vehicle']),
    );
  }
}

class Vehicles {
  final int id;
  final String name;
  final String brand;
  final String model;
  final String year;
  final double price;
  final String transmission;
  final String engine;
  final String status;

  Vehicles({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.transmission,
    required this.engine,
    required this.status,
  });

  factory Vehicles.fromJson(Map<String, dynamic> json) {
    return Vehicles(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      price: (json['price'] as num).toDouble(),
      transmission: json['transmission'],
      engine: json['engine'],
      status: json['status'],
    );
  }
}
