abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashNavigateToOnboard extends SplashState {
  const SplashNavigateToOnboard();
}

class SplashNavigateToLogin extends SplashState {
  const SplashNavigateToLogin();
}

class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);
}