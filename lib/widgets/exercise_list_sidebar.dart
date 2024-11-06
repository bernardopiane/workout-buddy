import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise_filters.dart';

class ExerciseListSidebar extends StatefulWidget {
  const ExerciseListSidebar({
    super.key,
    required this.activeFilters,
    required this.onFilterChanged,
  });
  final ExerciseFilters activeFilters;
  final Function(ExerciseFilters newFilters) onFilterChanged;

  @override
  State<ExerciseListSidebar> createState() => _ExerciseListSidebarState();
}

class _ExerciseListSidebarState extends State<ExerciseListSidebar> {
  late ExerciseFilters currentFilters;

  @override
  void initState() {
    super.initState();
    currentFilters = widget.activeFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Filters"),
          const SizedBox(height: 12.0),
          _buildFilterChips(),
          const SizedBox(height: 16.0),
          _buildSectionTitle("Categories"),
          const SizedBox(height: 12.0),
          _buildCategoryChips(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final muscle in primaryMuscles)
          _buildChip(
            label: muscle,
            isSelected: currentFilters.primaryMuscle == muscle,
            onTap: () {
              setState(() {
                if (currentFilters.primaryMuscle == muscle) {
                  currentFilters = currentFilters.copyWith(primaryMuscle: '');
                } else {
                  currentFilters =
                      currentFilters.copyWith(primaryMuscle: muscle);
                }
              });
              widget.onFilterChanged(currentFilters);
            },
          ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final category in categories)
          _buildChip(
            label: category,
            isSelected: currentFilters.category == category,
            onTap: () {
              setState(() {
                if (currentFilters.category == category) {
                  currentFilters = currentFilters.copyWith(category: '');
                } else {
                  currentFilters = currentFilters.copyWith(category: category);
                }
              });
              widget.onFilterChanged(currentFilters);
            },
          ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
