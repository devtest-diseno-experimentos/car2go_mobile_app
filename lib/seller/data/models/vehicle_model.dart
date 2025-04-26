class Vehicle {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String brand;
  final String model;
  final String color;
  final String year;
  final double price;
  final String transmission;
  final String engine;
  final double mileage;
  final String doors;
  final String plate;
  final String location;
  final String description;
  final List<String> image;
  final int profileId;
  final String fuel;
  final int speed;
  final String status;

  Vehicle({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.brand,
    required this.model,
    required this.color,
    required this.year,
    required this.price,
    required this.transmission,
    required this.engine,
    required this.mileage,
    required this.doors,
    required this.plate,
    required this.location,
    required this.description,
    required this.image,
    required this.profileId,
    required this.fuel,
    required this.speed,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      year: json['year'],
      price: (json['price'] as num).toDouble(),
      transmission: json['transmission'],
      engine: json['engine'],
      mileage: (json['mileage'] as num).toDouble(),
      doors: json['doors'],
      plate: json['plate'],
      location: json['location'],
      description: json['description'],
      image: List<String>.from(json['image']),
      profileId: json['profileId'],
      fuel: json['fuel'],
      speed: json['speed'],
      status: json['status'],
    );
  }
}
