import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/favorites.dart';
import 'package:workout_buddy/widgets/muscle_column.dart';

import '../widgets/exercise_equipment.dart';
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
                MuscleColumn(
                  title: 'Primary Muscles:',
                  muscles: exercise.primaryMuscles,
                ),
                const SizedBox(width: 12.0),
                if (exercise.secondaryMuscles != null &&
                    exercise.secondaryMuscles!.isNotEmpty)
                  MuscleColumn(
                    title: 'Secondary Muscles:',
                    muscles: exercise.secondaryMuscles,
                  ),
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

  Widget _buildCategoryAndEquipmentSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen is small or large based on available width
        bool isLargeScreen = constraints.maxWidth > 600;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: isLargeScreen
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: _buildCategorySection(context),
                    ),
                    const SizedBox(
                        width: 16.0), // Space between Category and Equipment
                    if (exercise.equipment != null &&
                        exercise.equipment!.isNotEmpty)
                      Flexible(
                        flex: 1,
                        child: _buildEquipmentSection(context),
                      ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategorySection(context),
                    const SizedBox(
                        height: 16.0), // Space between Category and Equipment
                    if (exercise.equipment != null &&
                        exercise.equipment!.isNotEmpty)
                      _buildEquipmentSection(context),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category:",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4.0),
        ExerciseCategory(exercise: exercise),
      ],
    );
  }

  Widget _buildEquipmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Equipment:",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4.0),
        ExerciseEquipment(exercise: exercise),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    final instructions = exercise.instructions;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Instructions:'),
          const SizedBox(height: 8.0),
          instructions != null && instructions.isNotEmpty
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instructions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Expanded(
                          child: Text(
                            instructions[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Text(
                  'No instructions available.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
