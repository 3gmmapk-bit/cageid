import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/news_article.dart';

class NewsService {
  final supabase = Supabase.instance.client;

  Future<List<NewsArticle>> getNews() async {
    final response = await supabase
        .from('news')
        .select()
        .order('created_at', ascending: false);

    return response.map<NewsArticle>((item) {
      return NewsArticle.fromJson(item);
    }).toList();
  }

  Future<void> addNews(NewsArticle article) async {
    await supabase.from('news').insert(article.toJson());
  }

  Future<void> deleteNews(String id) async {
    await supabase.from('news').delete().eq('id', id);
  }
}