class MediaItem {
  final String? id;
  final String title;
  final String imageUrl;
  final String category;
  final String? athleteId;
  final String? eventId;
  final String? gymId;

  MediaItem({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.athleteId,
    this.eventId,
    this.gymId,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? 'General',
      athleteId: json['athlete_id'],
      eventId: json['event_id'],
      gymId: json['gym_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image_url': imageUrl,
      'category': category,
      'athlete_id': athleteId,
      'event_id': eventId,
      'gym_id': gymId,
    };
  }
}