import 'package:flutter/material.dart';
import '../model/exercise.dart';
import '../pages/exercise_detail_page.dart';

class ExerciseDisplayWithShadow extends StatelessWidget {
  const ExerciseDisplayWithShadow({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Exercise Image
        if (exercise.images != null && exercise.images!.isNotEmpty)
          Image.asset(
            "lib/data/${exercise.images!.elementAt(0)}",
            fit: BoxFit.cover,
            alignment: Alignment.center,
          )
        else
          Container(color: Colors.grey), // Fallback for missing image

        // Top-left to bottom-center gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              stops: [0, 0.50],
            ),
          ),
        ),

        // Bottom-right to top-center gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.bottomRight,
              end: Alignment.topCenter,
              stops: [0, 0.50],
            ),
          ),
        ),

        // Exercise Name
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            exercise.name ?? "Unknown Exercise",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                )
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // More Details Link
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Text(
            'More details →',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),

        // Ripple effect for the entire card
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetail(exercise: exercise),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
