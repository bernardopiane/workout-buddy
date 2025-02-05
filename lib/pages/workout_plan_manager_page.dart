import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';

import '../model/workout_plan.dart';
import '../model/workout_plan_manager.dart';

class WorkoutPlanManagerPage extends StatelessWidget {
  const WorkoutPlanManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan Manager'),
        actions: [
          //   Button to debug workout plans
          Consumer<WorkoutPlanManager>(
            builder: (context, workoutPlanManager, child) {
              return IconButton(
                icon: const Icon(Icons.bug_report),
                onPressed: () {
                  //   Print all loaded workout plans
                  debugPrint(workoutPlanManager.workoutPlans.toString());
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkoutPlannerPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<WorkoutPlanManager>(
        builder: (context, workoutPlanManager, child) {
          return ListView.builder(
            itemCount: workoutPlanManager.workoutPlans.length,
            itemBuilder: (context, index) {
              final WorkoutPlan plan = workoutPlanManager.workoutPlans[index];
              return ListTile(
                title: Text(plan.planName),
                // TODO Create WorkoutPlanCard widget
                // Temporary quick description of the workout plan based on the number of days and exercises
                subtitle: Text(
                  '${plan.workoutDays.length} days, ${plan.workoutDays.map((day) => day.workouts.length).reduce((value, element) => value + element)} exercises',
                ),
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
