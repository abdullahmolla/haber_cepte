import 'package:flutter/material.dart';
import 'package:haber_cepte/core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String category;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.category = '',
    this.height = 180,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);

    if (imageUrl.trim().isEmpty) {
      return _CategoryPlaceholder(
        height: height,
        width: width,
        borderRadius: radius,
        category: category,
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEFF6FF),
                  Color(0xFFDBEAFE),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _CategoryPlaceholder(
            height: height,
            width: width,
            borderRadius: radius,
            category: category,
          );
        },
      ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final String category;

  const _CategoryPlaceholder({
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.category,
  });

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_soccer_rounded;
      case 'technology':
        return Icons.computer_rounded;
      case 'business':
        return Icons.trending_up_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'world':
        return Icons.public_rounded;
      default:
        return Icons.article_rounded;
    }
  }

  String get categoryTitle {
    switch (category.toLowerCase()) {
      case 'sports':
        return 'Spor';
      case 'technology':
        return 'Teknoloji';
      case 'business':
        return 'Ekonomi';
      case 'health':
        return 'Sağlık';
      case 'world':
        return 'Dünya';
      default:
        return 'Gündem';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
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
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: CircleAvatar(
                radius: 58,
                backgroundColor: Colors.white24,
              ),
            ),
            Positioned(
              left: -28,
              bottom: -28,
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white10,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: height < 150 ? 34 : 58,
                    height: height < 150 ? 34 : 58,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'HABER CEPTE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoryIcon,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          categoryTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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