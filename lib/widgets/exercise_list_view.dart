import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/exercise_filters.dart';
import '../model/exercise_list.dart';

class ExerciseListView extends StatelessWidget {
  const ExerciseListView({super.key, required this.filters});

  final ExerciseFilters filters;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseList>(
      builder: (context, exerciseList, child) {
        final List<Exercise> filteredExercises =
            exerciseList.exercises.where((exercise) {
          // Apply filters sequentially
          bool matchesFilters = true;

          if (filters.primaryMuscle.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.primaryMuscles
                        ?.contains(filters.primaryMuscle.toLowerCase()) ??
                    false);
          }
          if (filters.secondaryMuscle.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.secondaryMuscles
                        ?.contains(filters.secondaryMuscle.toLowerCase()) ??
                    false);
          }
          if (filters.level.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.level?.toLowerCase() == filters.level.toLowerCase());
          }
          if (filters.force.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.force?.toLowerCase() == filters.force.toLowerCase());
          }
          if (filters.equipment.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.equipment?.toLowerCase() ==
                    filters.equipment.toLowerCase());
          }
          if (filters.mechanic.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.mechanic?.toLowerCase() ==
                    filters.mechanic.toLowerCase());
          }
          if (filters.category.isNotEmpty) {
            matchesFilters = matchesFilters &&
                (exercise.category?.toLowerCase() ==
                    filters.category.toLowerCase());
          }

          return matchesFilters; // Return true if all filters match
        }).toList();

        // If list is empty, display a message
        if (filteredExercises.isEmpty) {
          return const Center(
            child: Text("No exercises found"),
          );
        }

        return ListView.builder(
          itemCount: filteredExercises.length,
          itemBuilder: (context, index) {
            final exercise = filteredExercises.elementAt(index);
            return ListTile(
              title: Text(exercise.name.toString()),
            );
          },
        );
      },
    );
  }
}
