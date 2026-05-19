import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _soundKey = 'sound_enabled';
  static const String _languageKey = 'language_code';
  static const String _currencyKey = 'currency_code';
  static const String _analyticsKey = 'analytics_enabled';
  static const String _vibrationKey = 'vibration_enabled';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme Mode
  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  // Notifications
  bool isNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  // Sound
  bool isSoundEnabled() {
    return _prefs.getBool(_soundKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundKey, enabled);
  }

  // Vibration
  bool isVibrationEnabled() {
    return _prefs.getBool(_vibrationKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_vibrationKey, enabled);
  }

  // Language
  String getLanguageCode() {
    return _prefs.getString(_languageKey) ?? 'en';
  }

  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }

  // Currency
  String getCurrencyCode() {
    return _prefs.getString(_currencyKey) ?? 'USD';
  }

  Future<void> setCurrencyCode(String code) async {
    await _prefs.setString(_currencyKey, code);
  }

  // Analytics
  bool isAnalyticsEnabled() {
    return _prefs.getBool(_analyticsKey) ?? true;
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool(_analyticsKey, enabled);
  }

  // Cache and Data Management
  Future<void> clearCache() async {
    await _prefs.clear();
    // Reinitialize defaults
    await init();
  }

  Future<void> resetToDefaults() async {
    await _prefs.remove(_themeModeKey);
    await _prefs.remove(_notificationsKey);
    await _prefs.remove(_soundKey);
    await _prefs.remove(_languageKey);
    await _prefs.remove(_currencyKey);
    await _prefs.remove(_analyticsKey);
    await _prefs.remove(_vibrationKey);
  }

  // Get all settings as a map for debugging
  Map<String, dynamic> getAllSettings() {
    return {
      'themeMode': getThemeMode(),
      'notificationsEnabled': isNotificationsEnabled(),
      'soundEnabled': isSoundEnabled(),
      'vibrationEnabled': isVibrationEnabled(),
      'languageCode': getLanguageCode(),
      'currencyCode': getCurrencyCode(),
      'analyticsEnabled': isAnalyticsEnabled(),
    };
  }
}
