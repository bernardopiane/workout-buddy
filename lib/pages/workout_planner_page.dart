import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/pages/workout_page.dart';
import 'package:workout_buddy/widgets/workout_selector.dart';

class WorkoutPlannerPage extends StatefulWidget {
  const WorkoutPlannerPage({super.key});

  @override
  State<WorkoutPlannerPage> createState() => _WorkoutPlannerPageState();
}

class _WorkoutPlannerPageState extends State<WorkoutPlannerPage>
    with TickerProviderStateMixin {
  List<WorkoutDay> workoutDays = List.empty(growable: true);
  int _index = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: workoutDays.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Planner'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _index,
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                children: [
                  if (details.stepIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        if (_index > 0) {
                          setState(() {
                            _index -= 1;
                          });
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_rounded),
                          SizedBox(width: 8),
                          Text("Previous"),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (details.stepIndex < 2)
                    ElevatedButton(
                      onPressed: () {
                        if (_index < 2) {
                          setState(() {
                            _index += 1;
                          });
                        }
                      },
                      child: const Row(
                        children: [
                          Text("Next"),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  // Last step, display a button to complete the workout
                  if (details.stepIndex == 2)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WorkoutPage(),
                        ));
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text("Complete"),
                        ],
                      ),
                    ),
                ],
              );
            },
            steps: <Step>[
              Step(
                isActive: _index >= 0,
                title: const Text('Select Days'),
                content: Wrap(
                  children: dayOfWeek.map((e) {
                    return CheckboxListTile(
                      title: Text(e),
                      value: workoutDays.any((element) => element.dayName == e),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            workoutDays.add(WorkoutDay(dayName: e, workouts: []));
                            // Reorder WorkoutDays to match the order of dayOfWeek
                            List<String> dayOrder = dayOfWeek.toList();
                            workoutDays.sort((a, b) {
                              return dayOrder.indexOf(a.dayName).compareTo(dayOrder.indexOf(b.dayName));
                            });
                          } else {
                            workoutDays.removeWhere((element) => element.dayName == e);
                          }

                          // Update the TabController to reflect the current number of tabs
                          _tabController = TabController(length: workoutDays.length, vsync: this);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Step(
                isActive: _index >= 1,
                title: const Text('Select Workouts'),
                content: workoutDays.isEmpty
                    ? const Center(child: Text('No days selected'))
                    : Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor:
                                Theme.of(context).colorScheme.onSurface,
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                            tabs: workoutDays
                                .map((day) => Tab(text: day.dayName))
                                .toList(),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: TabBarView(
                              controller: _tabController,
                              children: workoutDays.map((day) {
                                return WorkoutSelector(
                                  workoutDay: day,
                                  addWorkout: _addWorkout,
                                  removeWorkout: _removeWorkout,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
              ),
              Step(
                isActive: _index == 2,
                title: const Text("Summary"),
                state: _index == 2 ? StepState.complete : StepState.disabled,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text("Total workout days: ${workoutDays.length}"),
                    const SizedBox(height: 16),
                    Text(
                        "Total exercises: ${workoutDays.fold(0, (sum, day) => sum + day.workouts.length)}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .firstWhere((element) => element.dayName == workoutDay.dayName)
          .workouts
          .add(exercise);
    });
    debugPrint("Added ${exercise.name} to ${workoutDay.dayName}");
  }

  void _removeWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .firstWhere((element) => element.dayName == workoutDay.dayName)
          .workouts
          .remove(exercise);
    });
    debugPrint("Removed ${exercise.name} from ${workoutDay.dayName}");
  }
}
