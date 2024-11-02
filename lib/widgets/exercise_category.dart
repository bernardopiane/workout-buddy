import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseCategory extends StatelessWidget {
  const ExerciseCategory({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Increased elevation for better shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getIcon(exercise.category, context),
            const SizedBox(
                width: 16.0), // Increased space between icon and text
            Expanded(
              // Allow text to expand and occupy available space
              child: Text(
                exercise.category?.toUpperCase() ?? 'UNKNOWN',
                style: TextStyle(
                  fontSize: 20.0, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Use theme color
                  letterSpacing: 1.2, // Added letter spacing for readability
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Icon _getIcon(String? category, BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    switch (category?.toLowerCase()) {
      case 'strength':
        return Icon(Icons.fitness_center,
            color: primaryColor, size: 30); // Increased icon size
      case 'stretching':
        return Icon(Icons.self_improvement, color: primaryColor, size: 30);
      case 'plyometrics':
        return Icon(Icons.sports_kabaddi, color: primaryColor, size: 30);
      case 'strongman':
        return Icon(Icons.sports_handball, color: primaryColor, size: 30);
      case 'powerlifting':
        return Icon(Icons.power, color: primaryColor, size: 30);
      case 'cardio':
        return Icon(Icons.directions_run, color: primaryColor, size: 30);
      case 'olympic':
        return Icon(Icons.emoji_events, color: primaryColor, size: 30);
      case 'weightlifting':
        return Icon(Icons.sports_mma, color: primaryColor, size: 30);
      default:
        return Icon(
          Icons.circle_outlined,
          color: primaryColor,
          size: 30,
        );
    }
  }
}
