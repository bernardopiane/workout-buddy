import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/workout_day.dart';
import '../global.dart';
import '../model/exercise.dart';
import '../model/exercise_list.dart';
import 'filter_dropdown.dart';

class WorkoutSelector extends StatefulWidget {
  const WorkoutSelector({
    super.key,
    required this.workoutDay,
    required this.addWorkout,
    required this.removeWorkout,
  });

  final WorkoutDay workoutDay;
  final Function(WorkoutDay workoutDay, Exercise exercise) addWorkout;
  final Function(WorkoutDay workoutDay, Exercise exercise) removeWorkout;

  @override
  State<WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends State<WorkoutSelector> {
  String _searchQuery = '';
  String? selectedLevel;
  String? selectedPrimaryMuscle;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseList>(
      builder: (context, exerciseList, child) {
        Set<Exercise> exercises = exerciseList.getAllExercises();

        // Filter exercises based on the search query
        Set<Exercise> filteredExercises = exercises.where((exercise) {
          return exercise.name!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toSet();

        // Apply filters
        if (selectedLevel != null) {
          filteredExercises = filteredExercises
              .where((exercise) => exercise.level == selectedLevel)
              .toSet();
        }
        if (selectedPrimaryMuscle != null) {
          filteredExercises = filteredExercises
              .where((exercise) =>
                  exercise.primaryMuscles?.first == selectedPrimaryMuscle)
              .toSet();
        }
        if (selectedCategory != null) {
          filteredExercises = filteredExercises
              .where((exercise) => exercise.category == selectedCategory)
              .toSet();
        }

        return Column(
          children: [
            const Text(
              'Select Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Exercises',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            // Filter selection
            Row(
              children: [
                FilterDropdown(
                  hintText: 'Select Level',
                  value: selectedLevel,
                  options: difficultyLevels,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLevel = newValue;
                    });
                  },
                ),
                const SizedBox(width: 16.0),
                FilterDropdown(
                  hintText: 'Select Muscle',
                  value: selectedPrimaryMuscle,
                  options: primaryMuscles,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPrimaryMuscle = newValue;
                    });
                  },
                ),
                const SizedBox(width: 16.0),
                FilterDropdown(
                  hintText: 'Select Category',
                  value: selectedCategory,
                  options: categories,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            filteredExercises.isEmpty
                ? const Center(child: Text('No exercises found'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredExercises.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = filteredExercises.elementAt(index);

                        bool isSelected = widget.workoutDay.workouts
                            .any((e) => e.name == exercise.name);

                        return CheckboxListTile(
                          title: Text(exercise.name!),
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              widget.addWorkout(widget.workoutDay, exercise);
                            } else {
                              widget.removeWorkout(widget.workoutDay, exercise);
                            }
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
