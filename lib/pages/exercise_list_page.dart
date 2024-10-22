import 'package:flutter/material.dart';
import 'package:workout_buddy/widgets/exercise_list_view.dart';

import '../model/exercise_filters.dart';
import '../widgets/exercise_list_sidebar.dart';

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ExerciseFilters filters = ExerciseFilters();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise List Page"),
      ),
      drawer: const ExerciseListSidebar(),
      body: ExerciseListView(filters: filters),
    );
  }
}
