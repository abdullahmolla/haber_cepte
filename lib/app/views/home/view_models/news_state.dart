import 'package:haber_cepte/app/views/home/models/news_model.dart';

abstract class NewsState {
  const NewsState();
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;

  const NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);
}