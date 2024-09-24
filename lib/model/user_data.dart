import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier {
  String name;
  int age;
  double height;
  double weight;
  double weightGoal;
  List<UserWeightHistory> weightHistory; // Non-nullable
  DateTime? lastWeightDate;
  UserSettings userSettings;

  UserData({
    this.name = '',
    this.age = 0,
    this.height = 0.0,
    this.weight = 0.0,
    this.weightGoal = 0.0,
    List<UserWeightHistory>? weightHistory, // Nullable parameter
    UserSettings? userSettings,
  })  : weightHistory = weightHistory ?? [], // Initialize in initializer list
        userSettings = userSettings ?? UserSettings();

  setName(String name) {
    assert(name.isNotEmpty, 'Name cannot be empty');
    this.name = name;
    notifyListeners();
  }

  setAge(int age) {
    assert(age >= 0, 'Age cannot be negative');
    this.age = age;
    notifyListeners();
  }

  setHeight(double height) {
    assert(height >= 0, 'Height cannot be negative');
    this.height = height;
    notifyListeners();
  }

  setWeight(double weight) {
    assert(weight >= 0, 'Weight cannot be negative');
    this.weight = weight;
    lastWeightDate = DateTime.now();
    // Resets the weight history and adds the current weight to the history
    weightHistory.clear();
    weightHistory.add(UserWeightHistory(date: lastWeightDate!, weight: weight));
    notifyListeners();
  }

  setWeightGoal(double weightGoal) {
    assert(weightGoal >= 0, 'Weight goal cannot be negative');
    this.weightGoal = weightGoal;
    notifyListeners();
  }

  double getBMI() {
    double bmi = weight / pow(height / 100, 2);
    return double.parse(bmi.toStringAsFixed(2));
  }

  updateWeight(double weight) {
    // Update current weight
    this.weight = weight;
    // Add weight to weight history, date format is ISO 8601
    weightHistory.add(UserWeightHistory(date: lastWeightDate!, weight: weight));
    // Update last weight date
    lastWeightDate = DateTime.now();
    notifyListeners();
  }

  // Set and notify for useOnline in userSettings
  void setUseOnline(bool useOnline) {
    userSettings.useOnline = useOnline;
    notifyListeners();
    saveUserData(); // Save changes to SharedPreferences
  }

  // Set and notify for useMetric in userSettings
  void setUseMetric(bool useMetric) {
    debugPrint("Setting useMetric to $useMetric");
    userSettings.useMetric = useMetric;
    notifyListeners();
    saveUserData(); // Save changes to SharedPreferences
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0.0,
      weight: json['weight'] ?? 0.0,
      weightGoal: json['weightGoal'] ?? 0.0,
      //   Parse weight history from JSON
      weightHistory: json['weightHistory'] != null
          ? json['weightHistory']
              .map((e) => UserWeightHistory.fromJson(e))
              .toList()
          : [],
      //
      userSettings:
          UserSettings.fromJson(json['userSettings'] ?? UserSettings()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['weightGoal'] = weightGoal;
    data['weightHistory'] = weightHistory.map((e) => e.toJson()).toList();
    data['userSettings'] = userSettings.toJson();
    return data;
  }

//   Load and save user data to/from shared preferences
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(toJson());
    await prefs.setString('userData', encodedData);
    debugPrint("User data saved");
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('userData');
    if (encodedData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(encodedData);
      name = decodedData['name'];
      age = decodedData['age'];
      height = decodedData['height'];
      weight = decodedData['weight'];
      weightGoal = decodedData['weightGoal'];

      // Parse weightHistory properly
      if (decodedData['weightHistory'] != null) {
        weightHistory = (decodedData['weightHistory'] as List)
            .map((item) => UserWeightHistory.fromJson(item))
            .toList();
      }

      // Parse userSettings properly
      if (decodedData['userSettings'] != null) {
        userSettings = UserSettings.fromJson(decodedData['userSettings']);
      } else {
        userSettings = UserSettings(); // Default if no settings found
      }

      notifyListeners();
      debugPrint("User data loaded");
    }
  }
}

class UserWeightHistory {
  DateTime date;
  double weight;

  UserWeightHistory({required this.date, required this.weight});

  factory UserWeightHistory.fromJson(Map<String, dynamic> json) {
    return UserWeightHistory(
      date: DateTime.parse(json['date']),
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date.toString();
    data['weight'] = weight;
    return data;
  }
}

class UserSettings {
  bool useOnline;
  bool useMetric;

  UserSettings({this.useOnline = false, this.useMetric = true});

  // Factory method to create a UserSettings instance from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      useOnline: json['useOnline'] ?? false,
      useMetric: json['useMetric'] ?? true,
    );
  }

  // Convert UserSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'useOnline': useOnline,
      'useMetric': useMetric,
    };
  }
}
