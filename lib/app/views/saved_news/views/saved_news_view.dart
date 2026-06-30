import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/views/home/models/news_model.dart';
import 'package:haber_cepte/app/views/home/widgets/news_card.dart';
import 'package:haber_cepte/app/views/saved_news/view_models/saved_news_cubit.dart';
import 'package:haber_cepte/app/views/saved_news/view_models/saved_news_state.dart';
import 'package:haber_cepte/core/theme/app_colors.dart';
import 'package:haber_cepte/l10n/app_localizations.dart';

class SavedNewsView extends StatefulWidget {
  const SavedNewsView({super.key});

  @override
  State<SavedNewsView> createState() => _SavedNewsViewState();
}

class _SavedNewsViewState extends State<SavedNewsView> {
  String searchQuery = '';

  List<NewsModel> filterNews(List<NewsModel> news) {
    if (searchQuery.trim().isEmpty) return news;

    final query = searchQuery.toLowerCase();

    return news.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.sourceName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => SavedNewsCubit()..getSavedNews(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(lang.savedNews),
        ),
        body: BlocBuilder<SavedNewsCubit, SavedNewsState>(
          builder: (context, state) {
            if (state is SavedNewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SavedNewsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is SavedNewsLoaded) {
              final filteredNews = filterNews(state.news);

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<SavedNewsCubit>().getSavedNews();
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _SavedHeader(
                      totalCount: state.news.length,
                      onSearchChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    if (filteredNews.isEmpty)
                      const _EmptySavedNews()
                    else
                      ...filteredNews.map(
                        (news) {
                          return Dismissible(
                            key: ValueKey(news.title),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (_) {
                              context
                                  .read<SavedNewsCubit>()
                                  .deleteNews(news);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Haber silindi'),
                                ),
                              );
                            },
                            child: NewsCard(news: news),
                          );
                        },
                      ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _SavedHeader extends StatelessWidget {
  final int totalCount;
  final ValueChanged<String> onSearchChanged;

  const _SavedHeader({
    required this.totalCount,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bookmark_rounded,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Kaydedilen Haberler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$totalCount haber kaydedildi',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Kaydedilenlerde ara...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySavedNews extends StatelessWidget {
  const _EmptySavedNews();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 82,
                height: 82,
              ),
              const SizedBox(height: 18),
              Text(
                'Henüz kaydedilmiş haber yok',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Beğendiğin haberleri kaydet,\ndaha sonra kolayca oku.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}