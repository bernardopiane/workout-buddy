import 'package:flutter/material.dart';

class ExerciseListSidebar extends StatefulWidget { // Make it stateful
  const ExerciseListSidebar({super.key});


  @override
  State<ExerciseListSidebar> createState() => _ExerciseListSidebarState();
}

class _ExerciseListSidebarState extends State<ExerciseListSidebar> {
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterChip(
              label: const Text("Secondary Muscle"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Level"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Force"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Equipment"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Mechanic"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Category"),
              selected: true,
              onSelected: (bool value) {},
            ),
          ],
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
            FilterChip(
              label: const Text("Strength"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Stretching"),
              selected: true,
              onSelected: (bool value) {},
            ),
            FilterChip(
              label: const Text("Plyometrics"),
              selected: true,
              onSelected: (bool value) {},
            ),
            // Add more categories here
          ],
        ),
      ],
    );
  }
}
