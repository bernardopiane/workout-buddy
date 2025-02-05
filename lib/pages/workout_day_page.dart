import 'package:flutter/material.dart';

import '../model/exercise.dart';
import '../widgets/exercise_card.dart';

class WorkoutDayPage extends StatelessWidget {
  const WorkoutDayPage({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Day'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ExerciseCard(exercise: exercises[index]),
          );
        },
      ),
    );
  }
}
