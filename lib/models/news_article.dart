class NewsArticle {
  final String? id;
  final String title;
  final String content;
  final String? imageUrl;
  final String category;

  NewsArticle({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.category,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
    };
  }
}