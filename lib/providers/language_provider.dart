import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageProvider() {
    _initialize();
  }

  String _selectedLanguage = 'es';
  bool _isLoading = true;
  double _textScaleFactor = 1.0;
  bool _highContrast = false;

  String get selectedLanguage => _selectedLanguage;
  bool get isLoading => _isLoading;
  double get textScaleFactor => _textScaleFactor;
  bool get highContrast => _highContrast;

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString('language_code') ?? 'es';
    _textScaleFactor = prefs.getDouble('text_scale_factor') ?? 1.0;
    _highContrast = prefs.getBool('high_contrast') ?? false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'es' && languageCode != 'en') {
      return;
    }

    _selectedLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    notifyListeners();
  }

  Future<void> setTextScaleFactor(double value) async {
    _textScaleFactor = value.clamp(1.0, 1.6);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_scale_factor', _textScaleFactor);
    notifyListeners();
  }

  Future<void> setHighContrast(bool enabled) async {
    _highContrast = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_contrast', enabled);
    notifyListeners();
  }
}
