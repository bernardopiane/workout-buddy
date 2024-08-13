import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/widgets/workout_selector.dart';
import '../model/workout_plan.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Workout Planner Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Workout Day Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a workout day name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          workoutDay.dayName = value!;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Selectable Days of the Week',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      FilterDropdown(
                        hintText: 'Select Day',
                        showAllOption: false,
                        value: selectedDay,
                        options: dayOfWeek,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDay = newValue;
                            workoutDay.dayName = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return WorkoutSelector(
                                  workoutDay: workoutDay,
                                  addWorkout: _addWorkout,
                                  removeWorkout: _removeWorkout,
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Select Workouts'),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Selected Workouts',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: workoutDay.workouts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              workoutDay.workouts[index].name!,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _removeWorkout(workoutDay.workouts[index]);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Consumer<WorkoutPlan>(
                        builder: (context, workoutPlan, child) {
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    workoutPlan.addWorkoutDay(workoutDay);
                                  }
                                },
                                child: const Text('Save Workout Day'),
                              ),
                            //   Debug button to print workout plan
                              ElevatedButton(
                                onPressed: () {
                                  debugPrint(workoutPlan.toString());
                                },
                                child: const Text('Print Workout Plan'),
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addWorkout(Exercise exercise) {
    setState(() {
      workoutDay.workouts.add(exercise);
    });
    debugPrint("Added ${exercise.name} to workout day");
  }

  void _removeWorkout(Exercise exercise) {
    setState(() {
      workoutDay.workouts.remove(exercise);
    });
    debugPrint("Removed ${exercise.name} from workout day");
  }
}
