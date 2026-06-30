import 'package:go_router/go_router.dart';
import 'package:haber_cepte/app/routes/route_names.dart';
import 'package:haber_cepte/app/views/auth/views/forgot_password_view.dart';
import 'package:haber_cepte/app/views/auth/views/login_view.dart';
import 'package:haber_cepte/app/views/auth/views/register_view.dart';
import 'package:haber_cepte/app/views/onboard/views/onboard_view.dart';
import 'package:haber_cepte/app/views/splash/views/splash_view.dart';
import 'package:haber_cepte/app/views/home/views/home_view.dart';
import 'package:haber_cepte/app/views/news_detail/views/news_detail_view.dart';
import 'package:haber_cepte/app/views/home/models/news_model.dart';
import 'package:haber_cepte/app/views/saved_news/views/saved_news_view.dart';
import 'package:haber_cepte/app/views/main/views/main_view.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
  GoRoute(
    path: RouteNames.splash,
    builder: (context, state) => const SplashView(),
  ),
  GoRoute(
    path: RouteNames.onboard,
    builder: (context, state) => const OnboardView(),
  ),
  GoRoute(
    path: RouteNames.login,
    builder: (context, state) => const LoginView(),
  ),
  GoRoute(
    path: RouteNames.register,
    builder: (context, state) => const RegisterView(),
  ),
  GoRoute(
    path: RouteNames.forgotPassword,
    builder: (context, state) => const ForgotPasswordView(),
  ),
  GoRoute(
    path: RouteNames.home,
    builder: (context, state) => const HomeView(),
  ),

  GoRoute(
  path: RouteNames.main,
  builder: (context, state) => const MainView(),
),

    GoRoute(
  path: RouteNames.savedNews,
  builder: (context, state) => const SavedNewsView(),
),

  GoRoute(
  path: RouteNames.newsDetail,
  builder: (context, state) {
    final news = state.extra as NewsModel;

    return NewsDetailView(news: news);
  },
),

],
  );
}