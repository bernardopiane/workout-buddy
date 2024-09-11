import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/workout_plan.dart';
import '../model/workout_plan_manager.dart';

class WorkoutPlanManagerPage extends StatelessWidget {
  const WorkoutPlanManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan Manager'),
      ),
      body: Consumer<WorkoutPlanManager>(
        builder: (context, workoutPlanManager, child) {
          return ListView.builder(
            itemCount: workoutPlanManager.workoutPlans.length,
            itemBuilder: (context, index) {
              final WorkoutPlan plan = workoutPlanManager.workoutPlans[index];
              return ListTile(
                // Quick description of the workout plan based on the number of days and exercises
                subtitle: Text(
                  '${plan.workoutDays.length} days, ${plan.workoutDays.map((day) => day.workouts.length).reduce((value, element) => value + element)} exercises',
                ),
                title: Text(plan.planName),
                onTap: () {
                  workoutPlanManager.selectWorkoutPlan(plan);
                },
              );
            },
          );
        },
      ),
    );
  }
}
