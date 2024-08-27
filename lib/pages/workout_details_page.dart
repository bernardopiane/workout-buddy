import 'package:flutter/material.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/model/workout_plan.dart';

class WorkoutDetailsPage extends StatelessWidget {
  const WorkoutDetailsPage({super.key, required this.workoutPlan});
  final WorkoutPlan workoutPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Workout Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text("Total workout days: ${workoutPlan.workoutDays.length}"),
              const SizedBox(height: 16),
              Text(
                  "Total exercises: ${workoutPlan.workoutDays.fold(0, (sum, day) => sum + day.workouts.length)}"),
            ],
          ),
        ),
      ),
    );
  }
}
