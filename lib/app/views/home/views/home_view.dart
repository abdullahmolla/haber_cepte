import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haber_cepte/app/routes/route_names.dart';
import 'package:haber_cepte/app/views/home/models/news_model.dart';
import 'package:haber_cepte/app/views/home/view_models/news_cubit.dart';
import 'package:haber_cepte/app/views/home/view_models/news_state.dart';
import 'package:haber_cepte/app/views/home/widgets/news_card.dart';
import 'package:haber_cepte/core/theme/app_colors.dart';
import 'package:haber_cepte/core/widgets/app_network_image.dart';
import 'package:haber_cepte/l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedCategoryIndex = 0;
  int activeIndex = 0;
  String searchQuery = '';

  static const List<Map<String, String?>> categories = [
    {'key': 'all', 'value': null},
    {'key': 'sports', 'value': 'sports'},
    {'key': 'technology', 'value': 'technology'},
    {'key': 'business', 'value': 'business'},
    {'key': 'health', 'value': 'health'},
    {'key': 'world', 'value': 'world'},
  ];

  String categoryTitle(AppLocalizations lang, String key) {
    switch (key) {
      case 'all':
        return lang.categoryAll;
      case 'sports':
        return lang.categorySports;
      case 'technology':
        return lang.categoryTechnology;
      case 'business':
        return lang.categoryBusiness;
      case 'health':
        return lang.categoryHealth;
      case 'world':
        return lang.categoryWorld;
      default:
        return lang.categoryAll;
    }
  }

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
      create: (_) => NewsCubit()..getNews(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _HomeHeader(
                lang: lang,
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              Expanded(
                child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is NewsError) {
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

                    if (state is NewsLoaded) {
                      final filteredNews = filterNews(state.news);
                      final featuredNews = filteredNews.take(5).toList();

                      if (filteredNews.isEmpty) {
                        return Center(
                          child: Text(lang.noNews),
                        );
                      }

                      final selectedCategoryKey =
                          categories[selectedCategoryIndex]['key']!;

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context.read<NewsCubit>().getNews(
                                category: categories[selectedCategoryIndex]
                                    ['value'],
                              );
                        },
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                          children: [
                            _SectionTitle(
                              title: lang.breakingNews,
                              icon: Icons.local_fire_department_rounded,
                            ),
                            const SizedBox(height: 12),

                          CarouselSlider.builder(
                              itemCount: featuredNews.length,
                              itemBuilder: (context, index, realIndex) {
                                return _FeaturedNewsCard(
                                  news: featuredNews[index],
                        );
                        },
                                options: CarouselOptions(
                                height: 275,
                                autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                             autoPlayAnimationDuration: const Duration(milliseconds: 700),
                            viewportFraction: 0.90,
                          enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                    setState(() {
                    activeIndex = index;
                  });
                 },
                 ),
                ),

const SizedBox(height: 12),

AnimatedSmoothIndicator(
  activeIndex: activeIndex,
  count: featuredNews.length,
  effect: ExpandingDotsEffect(
    dotHeight: 8,
    dotWidth: 8,
    activeDotColor: AppColors.accent,
    dotColor: Colors.grey.shade300,
    expansionFactor: 3,
  ),
),

const SizedBox(height: 22),
                            const SizedBox(height: 22),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  List.generate(categories.length, (index) {
                                final category = categories[index];
                                final isSelected =
                                    selectedCategoryIndex == index;

                                return ChoiceChip(
                                  selected: isSelected,
                                  label: Text(
                                    categoryTitle(lang, category['key']!),
                                  ),
                                  selectedColor: AppColors.accent,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.accent
                                        : Colors.grey.shade300,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCategoryIndex = index;
                                    });

                                    context.read<NewsCubit>().getNews(
                                          category: category['value'],
                                        );
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 22),
                            _SectionTitle(
                              title: selectedCategoryKey == 'all'
                                  ? lang.dailyNews
                                  : '${categoryTitle(lang, selectedCategoryKey)} ${lang.news}',
                              icon: Icons.trending_up_rounded,
                            ),
                            const SizedBox(height: 12),
                            ...filteredNews.map(
                              (news) => NewsCard(news: news),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final AppLocalizations lang;
  final ValueChanged<String> onSearchChanged;

  const _HomeHeader({
    required this.lang,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 42,
                height: 42,
              ),
              const SizedBox(width: 10),
              Text(
                lang.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            lang.hello,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang.homeSubtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: lang.searchHint,
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _FeaturedNewsCard extends StatelessWidget {
  final NewsModel news;

  const _FeaturedNewsCard({
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        context.push(
          RouteNames.newsDetail,
          extra: news,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Stack(
      children: [
        AppNetworkImage(
          imageUrl: news.imageUrl,
          category: news.category,
          height: 130,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'SON DAKİKA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.sourceName.isNotEmpty
                        ? news.sourceName
                        : lang.newsSource,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}