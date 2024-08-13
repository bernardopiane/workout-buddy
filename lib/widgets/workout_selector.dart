import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/workout_day.dart';

import '../model/exercise.dart';
import '../model/exercise_list.dart';

class WorkoutSelector extends StatefulWidget {
  const WorkoutSelector({super.key, required this.workoutDay});
  final WorkoutDay workoutDay;

  @override
  State<WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends State<WorkoutSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseList>(
      builder: (context, exerciseList, child) {
        Set<Exercise> exercises = exerciseList.getAllExercises();

        return exercises.isEmpty
            ? const Center(child: Text('No exercises found'))
            : Column(
                children: [
                  const Text('Select Workouts'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        // Initialize is selected to false
                        bool isSelected = false;

                        // Check if the exercise is already in the workout plan
                        for (Exercise exercise in widget.workoutDay.workouts) {
                          if (exercise.name == exercises.elementAt(index).name) {
                            isSelected = true;
                          }
                        }

                        return CheckboxListTile(
                          title: Text(exercises.elementAt(index).name.toString()),
                          value: isSelected,
                          onChanged: (bool? value) {
                            // If the exercise is selected, add it to the workout plan
                            if (value == true) {
                              widget.workoutDay.addExercise(exercises.elementAt(index));
                            }
                            // If the exercise is deselected, remove it from the workout plan
                            else {
                              widget.workoutDay.removeExercise(exercises.elementAt(index));
                            }
                          //   Update the state of the checkbox
                            setState(() {
                              isSelected = value!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                    //   Close the bottom sheet
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
      },
    );
  }
}
