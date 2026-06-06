class Gym {
  final String? id;
  final String name;
  final String city;
  final String country;
  final String description;
  final String? logoUrl;

  Gym({
    this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.description,
    this.logoUrl,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'],
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? 'Pakistan',
      description: json['description'] ?? '',
      logoUrl: json['logo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'country': country,
      'description': description,
      'logo_url': logoUrl,
    };
  }
}