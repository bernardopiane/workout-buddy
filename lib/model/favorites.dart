import 'package:flutter/foundation.dart';
import 'package:workout_buddy/model/exercise.dart';

class Favorites extends ChangeNotifier {
  Set<Exercise> exercises;

  Favorites() : exercises = {};

  Favorites.fill(Iterable<Exercise> exercises) : exercises = exercises.toSet();

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
    return exercises.contains(e);
  }

  void handleClick(Exercise exercise) {
    isFavorite(exercise)
        ? removeFromFavorites(exercise)
        : addToFavorites(exercise);
  }
}
