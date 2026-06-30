import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/views/home/services/news_service.dart';
import 'package:haber_cepte/app/views/home/view_models/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(const NewsInitial());

  final NewsService _newsService = NewsService();

  Future<void> getNews({String? category}) async {
    try {
      emit(const NewsLoading());

      final news = await _newsService.getTopNews(category: category);

      emit(NewsLoaded(news));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
