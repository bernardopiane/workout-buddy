import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/widgets/workout_selector.dart';

import '../widgets/filter_dropdown.dart';

class WorkoutPlannerPage extends StatefulWidget {
  const WorkoutPlannerPage({super.key});

  @override
  State<WorkoutPlannerPage> createState() => _WorkoutPlannerPageState();
}

class _WorkoutPlannerPageState extends State<WorkoutPlannerPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDay;

  WorkoutDay workoutDay = WorkoutDay(dayName: "", workouts: []);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Text('Workout Planner Page'),
          //   Workout Day Form
          Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Workout Day Name',
                    ),
                  ),
                  //   Selectable days of the week
                  const Text('Selectable days of the week'),
                  FilterDropdown(
                    hintText: 'Select Day',
                    showAllOption: false,
                    value: selectedDay,
                    options: dayOfWeek,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue;
                        workoutDay = WorkoutDay(dayName: newValue!, workouts: []);
                      });
                    },
                  ),
                  // Display as a bottom sheet
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return WorkoutSelector(workoutDay: workoutDay);
                        },
                      );
                    },
                    child: const Text('Select Workouts'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
