import 'dart:convert';

import 'package:haber_cepte/app/views/home/models/news_model.dart';
import 'package:haber_cepte/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

class NewsService {
  Future<List<NewsModel>> getTopNews({String? category}) async {
  final String categoryQuery =
      category == null ? '' : '&category=$category';

  final Uri uri = Uri.parse(
    '${AppConstants.newsBaseUrl}?apikey=${AppConstants.newsApiKey}&country=tr&language=tr$categoryQuery',
  );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Haberler alınamadı');
  }

  final data = jsonDecode(response.body);
  final List results = data['results'] ?? [];

  return results.map((e) => NewsModel.fromJson(e)).toList();
}
}