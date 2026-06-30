class NewsModel {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String publishedAt;
  final String articleUrl;
  final String category;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.articleUrl,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      sourceName: json['source_name'] ?? '',
      publishedAt: json['pubDate'] ?? '',
      articleUrl: json['link'] ?? '',
      category: json['category'] is List && json['category'].isNotEmpty
          ? json['category'][0].toString()
          : '',
    );
  }
}