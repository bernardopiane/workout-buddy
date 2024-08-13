import 'package:workout_buddy/model/exercise.dart';

class WorkoutDay /*extends ChangeNotifier */ {
  String dayName; // e.g., "Monday", "Tuesday"
  final List<Exercise> workouts;

  // Create an empty constructor
  WorkoutDay.empty() : this(dayName: "", workouts: []);

  // Create a constructor with a day name and a list of workouts
  WorkoutDay({
    required this.dayName,
    List<Exercise>? workouts,
  }) : workouts = workouts ?? [];

  // Convert WorkoutDay to JSON
  Map<String, dynamic> toJson() {
    return {
      'dayName': dayName,
      'workouts': workouts.map((exercise) => exercise.toJson()).toList(),
    };
  }

  // Create WorkoutDay from JSON
  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      dayName: json['dayName'],
      workouts: (json['workouts'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return "WorkoutDay - dayName: $dayName - workouts: $workouts\n";
  }
}
