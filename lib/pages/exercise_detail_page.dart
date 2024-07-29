import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/widgets/exercise_level.dart';

import '../widgets/exercise_image_display.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.exercise});

  final Exercise exercise;

  final bool isFavorite = false;
  // TODO implement proper favorite using state management

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          debugPrint("Favorite Clicked");
        },
      ),
      appBar: AppBar(
        title: Text(exercise.name ?? 'Exercise Details'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExerciseImageDisplay(exercise: exercise),
            Wrap(
              children: exercise.instructions
                      ?.map((muscle) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              muscle,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ))
                      .toList() ??
                  [],
            ),
            const Text(
              'Muscles worked on:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Wrap(
                  children: exercise.primaryMuscles
                          ?.map((muscle) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  muscle.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ))
                          .toList() ??
                      [],
                ),
                Wrap(
                  children: exercise.secondaryMuscles
                          ?.map((muscle) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  muscle.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ))
                          .toList() ??
                      [],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Difficulty:"),
                Text(
                  exercise.level ?? '',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Category:"),
                Text(
                  exercise.category ?? '',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Equipment:"),
                Text(
                  exercise.equipment ?? '',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Level: ${exercise.level ?? ''}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
