import 'package:flutter/foundation.dart';
import 'package:workout_buddy/model/workout_day.dart';

class WorkoutPlan extends ChangeNotifier {
  final String planName;
  final List<WorkoutDay> days;

  WorkoutPlan()
      : planName = 'Untitled workout plan',
        days = []; // Empty constructor

  WorkoutPlan.filled(this.planName, this.days); // Constructor with parameters

  addWorkoutDay(WorkoutDay day) {
    days.add(day);
    notifyListeners();
  }

  removeWorkoutDay(WorkoutDay day) {
    days.remove(day);
    notifyListeners();
  }

  clearWorkoutDays() {
    days.clear();
    notifyListeners();
  }
}
