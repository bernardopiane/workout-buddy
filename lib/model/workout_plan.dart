import 'package:workout_buddy/model/workout_day.dart';

class WorkoutPlan {
  final String planName;
  final List<WorkoutDay> days;

  WorkoutPlan({
    required this.planName,
    required this.days,
  });

  addWorkoutDay(WorkoutDay day) {
    days.add(day);
  }

  removeWorkoutDay(WorkoutDay day) {
    days.remove(day);
  }

  clearWorkoutDays() {
    days.clear();
  }
}
