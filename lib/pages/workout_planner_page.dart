import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/widgets/workout_selector.dart';

class WorkoutPlannerPage extends StatefulWidget {
  const WorkoutPlannerPage({super.key});

  @override
  State<WorkoutPlannerPage> createState() => _WorkoutPlannerPageState();
}

class _WorkoutPlannerPageState extends State<WorkoutPlannerPage>
    with TickerProviderStateMixin {
  String? selectedDay;

  List<WorkoutDay> workoutDays = List.empty(growable: true);

  WorkoutDay workoutDay = WorkoutDay(dayName: "", workouts: []);

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stepper(
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 0) {
              setState(() {
                _index += 1;
                _tabController =
                    TabController(length: workoutDays.length, vsync: this);
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: <Step>[
            Step(
              title: const Text('Select Days'),
              content: Wrap(
                children: [
                  ...dayOfWeek.map((e) {
                    return CheckboxListTile(
                      title: Text(e),
                      value: workoutDays.any((element) => element.dayName == e),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            workoutDays
                                .add(WorkoutDay(dayName: e, workouts: []));
                          } else {
                            workoutDays
                                .removeWhere((element) => element.dayName == e);
                          }
                          _tabController = TabController(
                              length: workoutDays.length, vsync: this);
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            Step(
              title: const Text('Select Workouts'),
              content: workoutDays.isEmpty
                  ? const Center(child: Text('No days selected'))
                  : Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
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
          ],
        ),
      ),
    );
  }

  void _addWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .where((element) => element.dayName == workoutDay.dayName)
          .first
          .workouts
          .add(exercise);
    });
    debugPrint("Added ${exercise.name} to ${workoutDay.dayName}");
  }

  void _removeWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .where((element) => element.dayName == workoutDay.dayName)
          .first
          .workouts
          .remove(exercise);
    });
    debugPrint("Removed ${exercise.name} from ${workoutDay.dayName}");
  }
}
