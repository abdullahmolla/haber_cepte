import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static const String settingsBox = 'settingsBox';
  static const String onboardSeenKey = 'onboardSeen';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBox);
  }

  static Box get _settings => Hive.box(settingsBox);

  static bool getOnboardSeen() {
    return _settings.get(onboardSeenKey, defaultValue: false) as bool;
  }

  static Future<void> setOnboardSeen(bool value) async {
    await _settings.put(onboardSeenKey, value);
  }

  static const String themeKey = 'isDarkTheme';
static const String notificationKey = 'isNotificationEnabled';

static bool getDarkTheme() {
  return _settings.get(themeKey, defaultValue: false) as bool;
}

static Future<void> setDarkTheme(bool value) async {
  await _settings.put(themeKey, value);
}

static bool getNotificationEnabled() {
  return _settings.get(notificationKey, defaultValue: true) as bool;
}

static Future<void> setNotificationEnabled(bool value) async {
  await _settings.put(notificationKey, value);
}

static const String languageKey = 'languageCode';

static String getLanguageCode() {
  return _settings.get(languageKey, defaultValue: 'tr');
}

static Future<void> setLanguageCode(String value) async {
  await _settings.put(languageKey, value);
}


}