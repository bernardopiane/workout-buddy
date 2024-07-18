import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              height: 150,
              width: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "lib/data/${exercise.images!.elementAt(0).toString()}")),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(exercise.name.toString()),
                  Text(exercise.instructions.toString()),
                  const Text("More details ->"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
