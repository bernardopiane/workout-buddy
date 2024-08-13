import 'package:flutter/cupertino.dart';
import 'package:workout_buddy/model/exercise.dart';

class WorkoutDay extends ChangeNotifier {
  String dayName; // e.g., "Monday", "Tuesday"
  List<Exercise> workouts;

  WorkoutDay({
    required this.dayName,
    required this.workouts,
  });

  addExercise(Exercise exercise) {
    workouts.add(exercise);
    debugPrint("Added exercise to workout day");
    notifyListeners();
  }

  removeExercise(Exercise exercise) {
    workouts.remove(exercise);
    debugPrint("Removed exercise from workout day");
    notifyListeners();
  }

  clearExercises() {
    workouts.clear();
    debugPrint("Cleared workout day");
    notifyListeners();
  }
}
