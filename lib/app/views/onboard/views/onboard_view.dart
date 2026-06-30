import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haber_cepte/app/routes/route_names.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';
import 'package:haber_cepte/core/theme/app_colors.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<_OnboardItem> items = const [
    _OnboardItem(
      image: 'assets/images/onboard/onboard_1.png',
      title: 'Gündemi Anlık Takip Et',
      description:
          'Türkiye ve dünyadan en güncel haberleri hızlıca keşfet.',
    ),
    _OnboardItem(
      image: 'assets/images/onboard/onboard_2.png',
      title: 'Haberleri Kaydet',
      description:
          'Beğendiğin haberleri kaydet, istediğin zaman tekrar oku.',
    ),
    _OnboardItem(
      image: 'assets/images/onboard/onboard_3.png',
      title: 'Kategorileri Keşfet',
      description:
          'Spor, teknoloji, ekonomi ve daha fazlasını tek ekranda takip et.',
    ),
  ];

  Future<void> finishOnboard() async {
    await HiveService.setOnboardSeen(true);

    if (mounted) {
      context.go(RouteNames.login);
    }
  }

  void nextPage() {
    if (currentPage == items.length - 1) {
      finishOnboard();
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentPage == items.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Haber Cepte',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: finishOnboard,
                    child: const Text('Atla'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              item.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) {
                  final isActive = currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.accent : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextPage,
                  child: Text(isLastPage ? 'Başla' : 'İleri'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem {
  final String image;
  final String title;
  final String description;

  const _OnboardItem({
    required this.image,
    required this.title,
    required this.description,
  });
}