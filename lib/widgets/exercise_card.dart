import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/pages/exercise_detail_page.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseDetail(exercise: exercise)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseImage(),
              const SizedBox(width: 12.0),
              Flexible(
                child: Text(
                  exercise.name.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
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
