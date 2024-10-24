import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  bool _useDarkTheme;
  bool _useOnline;
  bool _useMetric;

  Settings(
      {bool useOnline = false,
        bool useMetric = true,
        bool useDarkTheme = false})
      : _useOnline = useOnline,
        _useMetric = useMetric,
        _useDarkTheme = useDarkTheme {
    _loadSettings(); // Call loadSettings in the initializer list
  }


  // Getters for the properties
  bool get useDarkTheme => _useDarkTheme;
  bool get useOnline => _useOnline;
  bool get useMetric => _useMetric;

  // Factory method to create a UserSettings instance from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      useOnline: json['useOnline'] ?? false,
      useMetric: json['useMetric'] ?? true,
      useDarkTheme: json['useDarkTheme'] ?? false,
    );
  }

  // Convert UserSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'useOnline': useOnline,
      'useMetric': useMetric,
      'useDarkTheme': useDarkTheme,
    };
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('settings');
      if (encodedData != null) {
        final Map<String, dynamic> decodedData = jsonDecode(encodedData);
        _useOnline = decodedData['useOnline'] ?? false;
        _useMetric = decodedData['useMetric'] ?? true;
        _useDarkTheme = decodedData['useDarkTheme'] ?? false;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading settings: $e");
      }
    }
  }

  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(toJson());
    await prefs.setString('settings', encodedData);
  }

  void toggleDarkTheme() {
    _useDarkTheme = !_useDarkTheme;
    saveSettings();
    notifyListeners();
  }

  // Setters for the properties (to trigger notifications)
  set useDarkTheme(bool value) {
    _useDarkTheme = value;
    saveSettings();
    notifyListeners();
  }

  set useOnline(bool value) {
    _useOnline = value;
    saveSettings();
    notifyListeners();
  }

  set useMetric(bool value) {
    _useMetric = value;
    saveSettings();
    notifyListeners();
  }
}
