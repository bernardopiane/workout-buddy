import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/model/workout_plan.dart';
import 'package:workout_buddy/pages/exercise_detail_page.dart';

import '../utils/text_utils.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildWorkoutDays(context),
              ],
            ),
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
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total Days: ${workoutPlan.workoutDays.length}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutDays(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workoutPlan.workoutDays.length,
      itemBuilder: (context, index) {
        final day = workoutPlan.workoutDays[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Text(
              day.dayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            childrenPadding: const EdgeInsets.all(16.0),
            children: [
              _buildWorkoutExercises(context, day),
              _buildPrimaryMuscles(context, day),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutExercises(BuildContext context, WorkoutDay day) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: day.workouts.length,
      itemBuilder: (context, index) {
        final exercise = day.workouts[index];
        return ListTile(
          leading: Icon(Icons.fitness_center,
              color: Theme.of(context).colorScheme.secondary),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetail(exercise: exercise),
              ),
            );
          },
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
      padding: const EdgeInsets.only(top: 16.0),
      // TODO: Make proper padding instead of ListTile
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.accessibility_new,
                color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: muscles
                    .map((muscle) => _buildMuscleChip(context, muscle))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleChip(BuildContext context, String muscle) {
    return Chip(
      label: Text(capitalize(muscle)),
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
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
