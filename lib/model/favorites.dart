import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_buddy/model/exercise.dart';

class Favorites extends ChangeNotifier {
  Set<Exercise> exercises;

  Favorites() : exercises = {};

  addToFavorites(Exercise e) {
    if (exercises.add(e)) {
      notifyListeners();
      debugPrint("Exercise added");
    }
  }

  removeFromFavorites(Exercise e) {
    if (exercises.remove(e)) {
      notifyListeners();
      debugPrint("Exercise removed");
    }
  }

  bool isFavorite(Exercise e) {
    return exercises.any((exercise) => exercise.id == e.id);
  }

  void toggleFavorite(Exercise exercise) {
    isFavorite(exercise)
        ? removeFromFavorites(exercise)
        : addToFavorites(exercise);
    saveFavorites();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(exercises.map((e) => e.toJson()).toList());
    await prefs.setString('favorites', encodedData);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('favorites');
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      exercises = decodedData.map((json) => Exercise.fromJson(json)).toSet();
      for (var element in exercises) {
        debugPrint(element.name);
      }
      notifyListeners();
    }
  }
}
