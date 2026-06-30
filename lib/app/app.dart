import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/routes/app_router.dart';
import 'package:haber_cepte/core/localization/locale_cubit.dart';
import 'package:haber_cepte/core/localization/locale_state.dart';
import 'package:haber_cepte/core/theme/app_theme.dart';
import 'package:haber_cepte/core/theme/theme_cubit.dart';
import 'package:haber_cepte/core/theme/theme_state.dart';
import 'package:haber_cepte/l10n/app_localizations.dart';

class HaberCepteApp extends StatelessWidget {
  const HaberCepteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: 'Haber Cepte',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode:
                    themeState.isDark ? ThemeMode.dark : ThemeMode.light,
                locale: Locale(localeState.languageCode),
                localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
                supportedLocales:
                  AppLocalizations.supportedLocales,
                routerConfig: AppRouter.router
              );
            },
          );
        },
      ),
    );
  }
}