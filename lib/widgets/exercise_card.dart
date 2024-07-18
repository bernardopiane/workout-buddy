import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for a more Material-like appearance
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        // Add InkWell for ink splash effect on tap (if needed)
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          // Handle tap action if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Adjust padding as needed
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseImage(),
              const SizedBox(width: 12.0), // Add spacing between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0), // Add vertical spacing
                    Text(
                      exercise.instructions.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0), // Add vertical spacing
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'More details →',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseImage() {
    return SizedBox(
      height: 150,
      width: 280,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          "lib/data/${exercise.images!.elementAt(0)}",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
