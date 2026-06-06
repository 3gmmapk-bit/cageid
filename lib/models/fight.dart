class Fight {
  final String id;
  final String eventId;
  final String fighterRed;
  final String fighterBlue;
  final String? winnerId;
  final String? method;
  final int? round;
  final String? fightTime;
  final String? weightClass;
  final bool isCompleted;

  Fight({
    required this.id,
    required this.eventId,
    required this.fighterRed,
    required this.fighterBlue,
    this.winnerId,
    this.method,
    this.round,
    this.fightTime,
    this.weightClass,
    required this.isCompleted,
  });

  factory Fight.fromJson(Map<String, dynamic> json) {
    return Fight(
      id: json['id'],
      eventId: json['event_id'],
      fighterRed: json['fighter_red'],
      fighterBlue: json['fighter_blue'],
      winnerId: json['winner_id'],
      method: json['method'],
      round: json['round'],
      fightTime: json['fight_time'],
      weightClass: json['weight_class'],
      isCompleted: json['is_completed'] ?? false,
    );
  }
}