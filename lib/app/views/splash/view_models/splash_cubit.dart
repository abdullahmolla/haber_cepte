import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/views/splash/view_models/splash_state.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> checkAppStatus() async {
    emit(const SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    final bool onboardSeen = HiveService.getOnboardSeen();

    if (!onboardSeen) {
      emit(const SplashNavigateToOnboard());
      return;
    }

    final User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      emit(const SplashNavigateToHome());
    } else {
      emit(const SplashNavigateToLogin());
    }
  }
}