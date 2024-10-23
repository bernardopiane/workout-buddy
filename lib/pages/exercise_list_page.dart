import 'package:flutter/material.dart';
import 'package:workout_buddy/widgets/exercise_list_view.dart';

import '../model/exercise_filters.dart';
import '../widgets/exercise_list_sidebar.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExerciseFilters filters = ExerciseFilters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise List Page"),
      ),
      drawer: ExerciseListSidebar(
          onFilterChanged: onFilterChanged, activeFilters: filters),
      body: ExerciseListView(filters: filters),
    );
  }

  onFilterChanged(ExerciseFilters newFilters) {
    debugPrint("Filters changed to: $newFilters");
    setState(() {
      filters = newFilters;
    });
    debugPrint("Active filters: ${filters.toString()}");
  }
}
