class Athlete {
  final String? id;
  final String fullName;
  final String nickname;
  final String gym;
  final String weightClass;
  final int wins;
  final int losses;
  final int draws;

  final String? profileImage;
  final String? bio;
  final String? instagram;
  final String? facebook;
  final String? country;

  Athlete({
    this.id,
    required this.fullName,
    required this.nickname,
    required this.gym,
    required this.weightClass,
    required this.wins,
    required this.losses,
    required this.draws,
    this.profileImage,
    this.bio,
    this.instagram,
    this.facebook,
    this.country,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      nickname: json['nickname'] ?? '',
      gym: json['gym'] ?? '',
      weightClass: json['weight_class'] ?? '',
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
      profileImage: json['profile_image'],
      bio: json['bio'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'nickname': nickname,
      'gym': gym,
      'weight_class': weightClass,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'profile_image': profileImage,
      'bio': bio,
      'instagram': instagram,
      'facebook': facebook,
      'country': country,
    };
  }
}