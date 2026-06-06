import 'package:flutter/material.dart';

import '../../models/news_article.dart';
import '../../services/news_service.dart';
import '../../services/role_service.dart';
import 'add_news_screen.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService service = NewsService();
  final RoleService roleService = RoleService();

  Future<void> openAddNews() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddNewsScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteNews(String id) async {
    await service.deleteNews(id);
    setState(() {});
  }

  Widget buildAddButton() {
    return FutureBuilder<bool>(
      future: roleService.canPublishNews(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: openAddNews,
          child: const Icon(Icons.add),
        );
      },
    );
  }

  Widget buildDeleteButton(String newsId) {
    return FutureBuilder<bool>(
      future: roleService.isSuperAdmin(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await deleteNews(newsId);
          },
        );
      },
    );
  }

  Widget buildNewsImage(String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox(
        height: 170,
        child: Center(
          child: Icon(Icons.article, size: 60),
        ),
      );
    }

    return Image.network(
      url,
      height: 170,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(
          height: 170,
          child: Center(
            child: Icon(Icons.broken_image, size: 60),
          ),
        );
      },
    );
  }

  String shortContent(String content) {
    if (content.length <= 120) {
      return content;
    }

    return '${content.substring(0, 120)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
      ),
      floatingActionButton: buildAddButton(),
      body: FutureBuilder<List<NewsArticle>>(
        future: service.getNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading news: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final news = snapshot.data ?? [];

          if (news.isEmpty) {
            return const Center(
              child: Text('No news posts yet.'),
            );
          }

          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final article = news[index];

              return Card(
                margin: const EdgeInsets.all(12),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNewsImage(article.imageUrl),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        shortContent(article.content),
                      ),
                    ),

                    ButtonBar(
                      children: [
                        TextButton(
                          child: const Text('Read More'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewsDetailScreen(
                                  article: article,
                                ),
                              ),
                            );
                          },
                        ),
                        if (article.id != null)
                          buildDeleteButton(article.id!),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}