import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

import '../widgets/exercise_image_display.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name ?? 'Exercise Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExerciseImageDisplay(exercise: exercise),
            const SizedBox(height: 16.0),
            buildSectionTitle(context, 'Instructions'),
            buildInstruction(exercise.instructions, context),
            const SizedBox(height: 16.0),
            buildSectionTitle(context, 'Primary Muscles'),
            buildMuscleChip(exercise.primaryMuscles),
            const SizedBox(height: 16.0),
            buildSectionTitle(context, 'Secondary Muscles'),
            buildMuscleChip(exercise.secondaryMuscles),
            const SizedBox(height: 16.0),
            buildSectionTitle(context, 'Details'),
            buildDetailRow('Category', exercise.category),
            buildDetailRow('Equipment', exercise.equipment),
            buildDetailRow('Force', exercise.force),
            buildDetailRow('Level', exercise.level),
            buildDetailRow('Mechanic', exercise.mechanic),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget buildInstruction(List<String>? instructions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions!.map((instruction) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            instruction,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }).toList(),
    );
  }

  Widget buildMuscleChip(List<String>? muscles) {
    return Wrap(
      spacing: 8.0, // Horizontal spacing between chips
      runSpacing: 4.0, // Vertical spacing between lines of chips
      children: muscles!.map((muscle) {
        return Chip(
          label: Text(muscle),
          backgroundColor: Colors.blue.shade100, // Customize the chip color
        );
      }).toList(),
    );
  }

  Widget buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}