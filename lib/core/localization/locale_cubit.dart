import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';
import 'package:haber_cepte/core/localization/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
      : super(
          LocaleState(
            languageCode: HiveService.getLanguageCode(),
          ),
        );

  Future<void> changeLanguage(String languageCode) async {
    await HiveService.setLanguageCode(languageCode);

    emit(
      LocaleState(
        languageCode: languageCode,
      ),
    );
  }
}