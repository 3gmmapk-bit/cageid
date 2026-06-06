class Coach {
  final String? id;
  final String name;
  final String specialization;
  final String gym;
  final String bio;
  final String? profileImage;
  final String country;

  Coach({
    this.id,
    required this.name,
    required this.specialization,
    required this.gym,
    required this.bio,
    this.profileImage,
    required this.country,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      gym: json['gym'] ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profile_image'],
      country: json['country'] ?? 'Pakistan',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'gym': gym,
      'bio': bio,
      'profile_image': profileImage,
      'country': country,
    };
  }
}