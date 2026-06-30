import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';
import 'package:haber_cepte/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            isDark: HiveService.getDarkTheme(),
          ),
        );

  Future<void> toggleTheme(bool value) async {
    await HiveService.setDarkTheme(value);

    emit(
      ThemeState(
        isDark: value,
      ),
    );
  }
}