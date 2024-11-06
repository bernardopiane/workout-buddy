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
    saveSelectedPlanToSharedPreferences();
    notifyListeners();
  }

  // Save all workout plans to SharedPreferences
  Future<bool> saveAllPlansToSharedPreferences() async {
    try {
      // Validate input data
      if (workoutPlans == null) {
        debugPrint('Error: workoutPlans is null');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      final List<String> plansJson = workoutPlans.map((plan) {
        try {
          // Validate plan data
          if (plan.planName == null || plan.planName.isEmpty) {
            throw Exception('Invalid plan name');
          }

          if (plan.workoutDays == null) {
            throw Exception('Workout days is null');
          }

          return jsonEncode({
            'planName': plan.planName,
            'days': plan.workoutDays.map((day) {
              // Validate each day before converting to JSON
              if (day == null) {
                throw Exception('Invalid workout day');
              }
              return day.toJson();
            }).toList(),
          });
        } catch (e) {
          debugPrint('Error encoding plan ${plan.planName}: $e');
          // Return a minimal valid JSON to prevent complete save failure
          return jsonEncode({
            'planName': 'Error Plan',
            'days': [],
          });
        }
      }).toList();

      // Validate the final list isn't empty
      if (plansJson.isEmpty) {
        debugPrint('Warning: Saving empty plans list');
      }

      // Save to SharedPreferences and return success status
      final success = await prefs.setStringList('workout_plans', plansJson);

      if (!success) {
        debugPrint('Failed to save workout plans to SharedPreferences');
      }

      return success;

    } catch (e) {
      debugPrint('Error saving workout plans: $e');
      return false;
    }
  }


  // Load all workout plans from SharedPreferences
  Future<void> loadAllPlansFromSharedPreferences() async {
    try {
      // Get instance of SharedPreferences correctly
      final prefs = await SharedPreferences.getInstance();

      // Get the stored plans
      final List<String>? plansJson = prefs.getStringList('workout_plans');

      if (plansJson != null && plansJson.isNotEmpty) {
        workoutPlans = plansJson.map((planJson) {
          try {
            final Map<String, dynamic> decodedPlan = jsonDecode(planJson);
            final String planName = decodedPlan['planName'] as String;

            // Safely cast to List<dynamic> and handle potential null
            final List<dynamic> daysJson = decodedPlan['days'] as List<dynamic>? ?? [];

            final List<WorkoutDay> loadedDays = daysJson
                .map((dayJson) => WorkoutDay.fromJson(dayJson as Map<String, dynamic>))
                .toList();

            return WorkoutPlan.filled(planName, loadedDays);
          } catch (e) {
            debugPrint('Error decoding plan: $e');
            // Return an empty plan or handle the error as needed
            return WorkoutPlan.filled('Error Plan', []);
          }
        }).toList();
      } else {
        // Initialize with empty list if no data found
        workoutPlans = [];
      }
    } catch (e) {
      debugPrint('Error loading workout plans: $e');
      // Initialize with empty list in case of error
      workoutPlans = [];
    }
  }

  // Save the currently selected workout plan to SharedPreferences
  Future<bool> saveSelectedPlanToSharedPreferences() async {
    try {
      // Validate selected plan
      if (selectedPlan == null) {
        debugPrint('No plan selected to save');
        return false;
      }

      // Validate plan name
      if (selectedPlan!.planName.isEmpty) {
        debugPrint('Selected plan has an empty name');
        return false;
      }

      // Get SharedPreferences instance correctly
      final prefs = await SharedPreferences.getInstance();

      // Save the plan name and return success status
      final success = await prefs.setString('selected_plan', selectedPlan!.planName);

      if (!success) {
        debugPrint('Failed to save selected plan to SharedPreferences');
      }

      return success;

    } catch (e) {
      debugPrint('Error saving selected plan: $e');
      return false;
    }
  }

  // Load the currently selected workout plan from SharedPreferences
  Future<void> loadSelectedPlanFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? selectedPlanName = prefs.getString('selected_plan');

      if (selectedPlanName != null && workoutPlans.isNotEmpty) {
        try {
          selectedPlan = workoutPlans.firstWhere(
                (plan) => plan.planName == selectedPlanName,
            orElse: () => workoutPlans.first,
          );
        } catch (e) {
          // In case firstWhere fails despite the orElse
          selectedPlan = workoutPlans.isNotEmpty ? workoutPlans.first : null;
        }
      } else if (workoutPlans.isNotEmpty) {
        selectedPlan = workoutPlans.first;
      } else {
        selectedPlan = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading selected plan: $e');
      // You might want to rethrow or handle the error differently
      selectedPlan = null;
      notifyListeners();
    }
  }
}
