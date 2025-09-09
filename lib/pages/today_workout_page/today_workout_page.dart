import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/workout_plan.dart';
import '../../providers/workout_plan_manager.dart';

class TodayWorkoutPage extends StatelessWidget {
  const TodayWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Workout'),
      ),
      body: SafeArea(
        child: Selector<WorkoutPlanManager, WorkoutPlan?>(
            selector: (context, manager) => manager.selectedPlan,
            builder: (context, selectedPlan, child) {
              if (selectedPlan == null) {
                return const Text('No plan selected');
              } else {
                return Column(
                  children: [
                    Text(selectedPlan.planName),
                    const SizedBox(height: 16)
                  ],
                );
              }
            }),
      ),
    );
  }
}
