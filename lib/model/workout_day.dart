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
  //
  // /// Sets a new day name and notifies listeners
  // void setDayName(String newDayName) {
  //   if (newDayName != dayName) {
  //     dayName = newDayName;
  //     debugPrint("Set day name to $newDayName");
  //     notifyListeners();
  //   }
  // }
  //
  // /// Adds a list of exercises and notifies listeners
  // void addAllExercises(List<Exercise> exercises) {
  //   workouts.addAll(exercises);
  //   debugPrint("Added all exercises to workout day");
  //   notifyListeners();
  // }
  //
  // /// Adds a single exercise and notifies listeners
  // void addExercise(Exercise exercise) {
  //   if (!workouts.contains(exercise)) {
  //     workouts.add(exercise);
  //     debugPrint("Added exercise to workout day");
  //     notifyListeners();
  //   }
  // }
  //
  // /// Removes a single exercise and notifies listeners
  // void removeExercise(Exercise exercise) {
  //   if (workouts.remove(exercise)) {
  //     debugPrint("Removed exercise from workout day");
  //     notifyListeners();
  //   }
  // }
  //
  // /// Clears all exercises and notifies listeners
  // void clearExercises() {
  //   if (workouts.isNotEmpty) {
  //     workouts.clear();
  //     debugPrint("Cleared workout day");
  //     notifyListeners();
  //   }
  // }
}
