import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseCategory extends StatelessWidget {
  const ExerciseCategory({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    // Display different icons based on the category
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getIcon(exercise.category),
        const SizedBox(width: 8.0),
        Text(
          exercise.category ?? '',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _getIcon(String? category) {
    // TODO get correct icons
    if (category == "strength") {
      return const Icon(Icons.work);
    } else if (category == "stretching") {
      return const Icon(Icons.vertical_split_outlined);
    } else if (category == "plyometrics") {
      return const Icon(Icons.sports_bar_outlined);
    } else if (category == "strongman") {
      return const Icon(Icons.add);
    } else if (category == "powerlifting") {
      return const Icon(Icons.ac_unit);
    } else if (category == "cardio") {
      return const Icon(Icons.fitness_center_outlined);
    } else if (category == "olympic") {
      return const Icon(Icons.access_alarm);
    } else if (category == "weightlifting") {
      return const Icon(Icons.access_time_filled_outlined);
    } else {
      return const Icon(Icons.circle_outlined);
    }
  }
}
