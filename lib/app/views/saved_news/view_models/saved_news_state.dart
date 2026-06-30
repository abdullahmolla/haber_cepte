import 'package:haber_cepte/app/views/home/models/news_model.dart';

abstract class SavedNewsState {
  const SavedNewsState();
}

class SavedNewsInitial extends SavedNewsState {
  const SavedNewsInitial();
}

class SavedNewsLoading extends SavedNewsState {
  const SavedNewsLoading();
}

class SavedNewsLoaded extends SavedNewsState {
  final List<NewsModel> news;

  const SavedNewsLoaded(this.news);
}

class SavedNewsError extends SavedNewsState {
  final String message;

  const SavedNewsError(this.message);
}