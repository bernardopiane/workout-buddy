import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/favorites.dart';

import '../widgets/equipment.dart';
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              favoritesNotifier.isFavorite(exercise)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
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
            const SizedBox(height: 16.0),
            _buildSectionTitle(context, 'Muscles worked on:'),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMuscleColumn(
                    context, 'Primary Muscles:', exercise.primaryMuscles),
                const SizedBox(width: 12.0),
                if (exercise.secondaryMuscles != null &&
                    exercise.secondaryMuscles!.isNotEmpty)
                  _buildMuscleColumn(
                      context, 'Secondary Muscles:', exercise.secondaryMuscles),
              ],
            ),
            const Divider(height: 32.0),
            _buildCategoryAndEquipmentSection(context),
            const Divider(height: 32.0),
            _buildInstructionsSection(context),
            const Divider(height: 32.0),
            _buildRelatedExercisesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildMuscleColumn(
      BuildContext context, String title, List<String>? muscles) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Wrap(
            children: muscles
                    ?.map(
                      (muscle) => Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                        child: Chip(
                          label: Text(muscle.toUpperCase()),
                          backgroundColor:
                              Theme.of(context).chipTheme.backgroundColor,
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAndEquipmentSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category:",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            ExerciseCategory(exercise: exercise),
          ],
        ),
        if (exercise.equipment != null && exercise.equipment!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Equipment:",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),
              Equipment(exercise: exercise),
            ],
          ),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Instructions:'),
        const SizedBox(height: 8.0),
        Wrap(
          children: exercise.instructions
                  ?.map((instruction) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          instruction,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ))
                  .toList() ??
              [],
        ),
      ],
    );
  }

  Widget _buildRelatedExercisesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Related Exercises:'),
        const SizedBox(height: 8.0),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: RelatedExercises(exercise: exercise),
        ),
      ],
    );
  }
}
