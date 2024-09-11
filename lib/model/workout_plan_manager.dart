import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/model/workout_plan.dart';

class WorkoutPlanManager extends ChangeNotifier {
  List<WorkoutPlan> workoutPlans = [];
  WorkoutPlan? selectedPlan;

  // Add a new workout plan
  void addWorkoutPlan(WorkoutPlan plan) {
    workoutPlans.add(plan);
    // If there is no selected plan, select the new plan
    if (selectedPlan == null) {
      selectWorkoutPlan(plan);
    }
    notifyListeners();
    saveAllPlansToSharedPreferences();
  }

  // Remove a workout plan
  void removeWorkoutPlan(WorkoutPlan plan) {
    workoutPlans.remove(plan);
    if (selectedPlan == plan) {
      selectedPlan = null; // Clear selected plan if it's removed
    }
    notifyListeners();
    saveAllPlansToSharedPreferences();
  }

  // Select a workout plan
  void selectWorkoutPlan(WorkoutPlan plan) {
    selectedPlan = plan;
    notifyListeners();
    saveSelectedPlanToSharedPreferences();
  }

  // Save all workout plans to SharedPreferences
  Future<void> saveAllPlansToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> plansJson = workoutPlans
        .map((plan) => jsonEncode({
              'planName': plan.planName,
              'days': plan.workoutDays.map((day) => day.toJson()).toList(),
            }))
        .toList();
    await prefs.setStringList('workout_plans', plansJson);
  }

  // Load all workout plans from SharedPreferences
  Future<void> loadAllPlansFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? plansJson = prefs.getStringList('workout_plans');
    if (plansJson != null) {
      workoutPlans = plansJson.map((planJson) {
        final Map<String, dynamic> decodedPlan = jsonDecode(planJson);
        final String planName = decodedPlan['planName'];
        final List<dynamic> daysJson = decodedPlan['days'];
        final List<WorkoutDay> loadedDays =
            daysJson.map((dayJson) => WorkoutDay.fromJson(dayJson)).toList();
        // Get the selected plan from SharedPreferences
        return WorkoutPlan.filled(planName, loadedDays);
      }).toList();
    }
  }

  // Save the currently selected workout plan to SharedPreferences
  Future<void> saveSelectedPlanToSharedPreferences() async {
    if (selectedPlan != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_plan', selectedPlan!.planName);
    }
  }

  // Load the currently selected workout plan from SharedPreferences
  Future<void> loadSelectedPlanFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedPlanName = prefs.getString('selected_plan');

    if (selectedPlanName != null && workoutPlans.isNotEmpty) {
      selectedPlan = workoutPlans.firstWhere(
        (plan) => plan.planName == selectedPlanName,
        orElse: () =>
            workoutPlans.first, // Return the first plan if no match is found
      );
    } else if (workoutPlans.isNotEmpty) {
      selectedPlan = workoutPlans
          .first; // If no plan name is found, fallback to the first plan
    } else {
      selectedPlan = null; // Set to null if there are no workout plans
    }

    notifyListeners();
  }
}
