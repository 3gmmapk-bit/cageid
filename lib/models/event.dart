class FightEvent {
  final String id;
  final String name;
  final String? eventDate;
  final String? venue;
  final String? city;
  final String? country;

  FightEvent({
    required this.id,
    required this.name,
    this.eventDate,
    this.venue,
    this.city,
    this.country,
  });

  factory FightEvent.fromJson(Map<String, dynamic> json) {
    return FightEvent(
      id: json['id'],
      name: json['name'] ?? '',
      eventDate: json['event_date'],
      venue: json['venue'],
      city: json['city'],
      country: json['country'],
    );
  }
}