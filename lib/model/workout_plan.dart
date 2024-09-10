import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_buddy/model/workout_day.dart';

class WorkoutPlan extends ChangeNotifier {
  String planName;
  List<WorkoutDay> workoutDays;
  String id;

  WorkoutPlan()
      : id = UniqueKey().toString(),
        planName = 'Untitled workout plan',
        workoutDays = [];

  WorkoutPlan.filled(this.planName, this.workoutDays)
      : id = UniqueKey().toString();

  // Set plan name
  void setPlanName(String name) {
    planName = name;
    notifyListeners();
    saveToSharedPreferences();
  }

  // Add a workout day to the plan
  void addWorkoutDay(WorkoutDay day) {
    workoutDays.add(day);
    notifyListeners();
    saveToSharedPreferences(); // Save state to SharedPreferences
  }

  // Set workout days
  void setWorkoutDays(List<WorkoutDay> days) {
    workoutDays = days;
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
  Future<void> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutPlanJson = prefs.getString('workout_plan');
    debugPrint("Loaded workout plan from SharedPreferences: $workoutPlanJson");

    if (workoutPlanJson != null) {
      final Map<String, dynamic> decodedPlan = jsonDecode(workoutPlanJson);
      final String loadedPlanName = decodedPlan['planName'];
      final List<dynamic> daysJson = decodedPlan['days'];
      final List<WorkoutDay> loadedDays =
          daysJson.map((dayJson) => WorkoutDay.fromJson(dayJson)).toList();
      planName = loadedPlanName;
      workoutDays = loadedDays;
      notifyListeners();
      debugPrint("Loaded workout plan from SharedPreferences");
    }
  }

  @override
  String toString() {
    return "WorkoutPlan - planName: $planName - workoutDays: $workoutDays";
  }
}
