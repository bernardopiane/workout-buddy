import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_buddy/model/workout_day.dart';

class WorkoutPlan extends ChangeNotifier {
  final String planName;
  final List<WorkoutDay> workoutDays;

  WorkoutPlan()
      : planName = 'Untitled workout plan',
        workoutDays = [];

  WorkoutPlan.filled(this.planName, this.workoutDays);

  // Add a workout day to the plan
  void addWorkoutDay(WorkoutDay day) {
    workoutDays.add(day);
    notifyListeners();
    saveToSharedPreferences(); // Save state to SharedPreferences
  }

  // Remove a workout day from the plan
  void removeWorkoutDay(WorkoutDay day) {
    workoutDays.remove(day);
    notifyListeners();
    saveToSharedPreferences(); // Save state to SharedPreferences
  }

  // Clear all workout days
  void clearWorkoutDays() {
    workoutDays.clear();
    notifyListeners();
    saveToSharedPreferences(); // Save state to SharedPreferences
  }

  // Save the workout plan to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutPlanJson = jsonEncode({
      'planName': planName,
      'days': workoutDays.map((day) => day.toJson()).toList(),
    });
    await prefs.setString('workout_plan', workoutPlanJson);
    debugPrint("Saved workout plan to SharedPreferences");
  }

  // Load the workout plan from SharedPreferences
  static Future<WorkoutPlan> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutPlanJson = prefs.getString('workout_plan');

    if (workoutPlanJson != null) {
      final Map<String, dynamic> decodedPlan = jsonDecode(workoutPlanJson);
      final String planName = decodedPlan['planName'];
      final List<dynamic> daysJson = decodedPlan['days'];
      final List<WorkoutDay> loadedDays =
          daysJson.map((dayJson) => WorkoutDay.fromJson(dayJson)).toList();
      return WorkoutPlan.filled(planName, loadedDays);
    } else {
      return WorkoutPlan(); // Return an empty plan if nothing is saved
    }
  }

  @override
  String toString() {
    return "WorkoutPlan - planName: $planName - workoutDays: $workoutDays";
  }
}
