import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/views/home/models/news_model.dart';
import 'package:haber_cepte/app/views/saved_news/services/saved_news_service.dart';
import 'package:haber_cepte/app/views/saved_news/view_models/saved_news_state.dart';

class SavedNewsCubit extends Cubit<SavedNewsState> {
  SavedNewsCubit() : super(const SavedNewsInitial());

  final SavedNewsService _service = SavedNewsService();

  Future<void> getSavedNews() async {
    try {
      emit(const SavedNewsLoading());

      final news = await _service.getSavedNews();

      emit(SavedNewsLoaded(news));
    } catch (e) {
      emit(SavedNewsError(e.toString()));
    }
  }

  Future<void> deleteNews(NewsModel news) async {
    try {
      await _service.deleteSavedNews(news);

      await getSavedNews();
    } catch (e) {
      emit(SavedNewsError(e.toString()));
    }
  }
}