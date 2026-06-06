class Athlete {
  final String? id;
  final String fullName;
  final String nickname;
  final String gym;
  final String weightClass;
  final int wins;
  final int losses;
  final int draws;

  Athlete({
    this.id,
    required this.fullName,
    required this.nickname,
    required this.gym,
    required this.weightClass,
    required this.wins,
    required this.losses,
    required this.draws,
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
    };
  }
}