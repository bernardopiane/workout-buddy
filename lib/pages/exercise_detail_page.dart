import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/favorites.dart';

import '../widgets/exercise_category.dart';
import '../widgets/exercise_image_display.dart';
import '../widgets/related_exercises.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<Favorites>(
        builder: (context, favoritesNotifier, child) {
          return FloatingActionButton(
            child: Icon(favoritesNotifier.isFavorite(exercise)
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              favoritesNotifier.toggleFavorite(exercise);
            },
          );
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
            const Text(
              'Muscles worked on:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary Muscles:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: exercise.primaryMuscles
                              ?.map(
                                (muscle) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Chip(
                                    label: Text(muscle.toUpperCase()),
                                    backgroundColor: Theme.of(context)
                                        .chipTheme
                                        .backgroundColor,
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ],
                ),
                const SizedBox(width: 12.0),
                // If exercise.secondaryMuscles is not null, display it
                if (exercise.secondaryMuscles != null &&
                    exercise.secondaryMuscles!.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Secondary Muscles:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: exercise.secondaryMuscles
                                ?.map(
                                  (muscle) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Chip(
                                      label: Text(muscle.toUpperCase()),
                                      backgroundColor: Theme.of(context)
                                          .chipTheme
                                          .backgroundColor,
                                    ),
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ],
                  ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Category:",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                ExerciseCategory(exercise: exercise),
              ],
            ),
            // If exercise.equipment is not null, display it
            if (exercise.equipment != null && exercise.equipment!.isNotEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Equipment:",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text(
                    exercise.equipment ?? '',
                  ),
                ],
              ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: RelatedExercises(exercise: exercise),
            )
          ],
        ),
      ),
    );
  }
}
