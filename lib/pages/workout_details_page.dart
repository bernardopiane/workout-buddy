import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/model/workout_plan.dart';
import 'package:workout_buddy/utils.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutDetailsPage({super.key, required this.workoutPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Handle edit functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildWorkoutDays(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workoutPlan.planName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total Days: ${workoutPlan.workoutDays.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutDays(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workoutPlan.workoutDays.map((day) {
        return ExpansionTile(
          title: Text(
            day.dayName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            _buildWorkoutExercises(day),
            _buildPrimaryMuscles(context, day),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutExercises(WorkoutDay day) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: day.workouts.length,
      itemBuilder: (context, index) {
        final exercise = day.workouts[index];
        return ListTile(
          leading: const Icon(Icons.fitness_center),
          title: Text(
            exercise.name!,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  Widget _buildPrimaryMuscles(BuildContext context, WorkoutDay day) {
    final muscles = getPrimaryMuscles(day);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.accessibility_new, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: muscles.map((muscle) {
                return Chip(
                  label: Text(capitalize(muscle)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Set<String> getPrimaryMuscles(WorkoutDay workoutDay) {
    Set<String> muscles = <String>{};
    for (Exercise exercise in workoutDay.workouts) {
      muscles.addAll(exercise.primaryMuscles!);
    }
    return muscles;
  }
}
