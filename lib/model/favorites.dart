import 'package:flutter/foundation.dart';
import 'package:workout_buddy/model/exercise.dart';

class Favorites extends ChangeNotifier {
  List<Exercise> exercises;

  Favorites() : exercises = [];

  Favorites.fill(this.exercises);

  addToFavorites(Exercise e) {
    if (!exercises.contains(e)) {
      exercises.add(e);
      notifyListeners();
      debugPrint("Exercise removed");
    }
  }

  removeFromFavorites(Exercise e) {
    exercises.removeWhere((current) => current.id == e.id);
    notifyListeners();
    debugPrint("Exercise removed");
  }

  bool isFavorite(Exercise e) {
    if (exercises.contains(e)) {
      return true;
    }
    return false;
  }

  void handleClick(Exercise exercise) {
    if (!isFavorite(exercise)) {
      addToFavorites(exercise);
    } else {
      removeFromFavorites(exercise);
    }
  }
}
