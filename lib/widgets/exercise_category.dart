import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseCategory extends StatelessWidget {
  const ExerciseCategory({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getIcon(exercise.category),
            const SizedBox(width: 8.0),
            Text(
              exercise.category?.toUpperCase() ?? 'UNKNOWN',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO get correct icons
  static Icon _getIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'strength':
        return const Icon(Icons.fitness_center);
      case 'stretching':
        return const Icon(Icons.self_improvement);
      case 'plyometrics':
        return const Icon(Icons.sports_kabaddi);
      case 'strongman':
        return const Icon(Icons.sports_handball);
      case 'powerlifting':
        return const Icon(Icons.power);
      case 'cardio':
        return const Icon(Icons.directions_run);
      case 'olympic':
        return const Icon(Icons.emoji_events);
      case 'weightlifting':
        return const Icon(Icons.sports_mma);
      default:
        return const Icon(Icons.circle_outlined);
    }
  }
}
