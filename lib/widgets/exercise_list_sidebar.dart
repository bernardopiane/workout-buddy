import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise_filters.dart';
import 'package:workout_buddy/widgets/filter_dropdown.dart';

class ExerciseListSidebar extends StatefulWidget {
  const ExerciseListSidebar(
      {super.key, required this.activeFilters, required this.onFilterChanged});
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
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          _buildFilterSection(context),
          const SizedBox(height: 16.0),
          _buildCategorySection(context),
        ],
      ),
    );
  }

  _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Filters",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterDropdown(
                hintText: 'Select Muscle',
                value: currentFilters.primaryMuscle.isNotEmpty
                    ? currentFilters.primaryMuscle
                    : null,
                options: primaryMuscles,
                onChanged: (String? newValue) {
                  setState(() {
                    // Update the local filter state
                    if (newValue == null) {
                      currentFilters =
                          currentFilters.copyWith(primaryMuscle: '');
                    } else {
                      currentFilters =
                          currentFilters.copyWith(primaryMuscle: newValue);
                    }
                  });

                  // Notify parent widget of filter change
                  widget.onFilterChanged(currentFilters);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterDropdown(
                hintText: 'Select Category',
                value: null,
                options: categories,
                onChanged: (String? newValue) {
                  setState(() {
                    // Update the local filter state
                    if (newValue == null) {
                      currentFilters = currentFilters.copyWith(category: '');
                    } else {
                      currentFilters =
                          currentFilters.copyWith(category: newValue);
                    }
                  });

                  // Notify parent widget of filter change
                  widget.onFilterChanged(currentFilters);
                }),
            // Add more categories here
          ],
        ),
      ],
    );
  }
}
