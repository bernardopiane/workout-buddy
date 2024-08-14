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
  final _formKey = GlobalKey<FormState>();
  String? selectedDay;

  WorkoutDay workoutDay = WorkoutDay(dayName: "", workouts: []);

  List<String> selectedDays = <String>[];

  int _index = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: selectedDays.length, vsync: this);
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
                    TabController(length: selectedDays.length, vsync: this);
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
                      value: selectedDays.contains(e),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedDays.add(e);
                          } else {
                            selectedDays.remove(e);
                          }
                          _tabController = TabController(
                              length: selectedDays.length, vsync: this);
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            Step(
              title: const Text('Select Workouts'),
              content: selectedDays.isEmpty
                  ? const Center(child: Text('No days selected'))
                  : Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabs: selectedDays
                              .map((day) => Tab(text: day))
                              .toList(),
                        ),
                        // TODO modify to work with workouts by day
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: TabBarView(
                            controller: _tabController,
                            children: selectedDays.map((day) {
                              return WorkoutSelector(
                                workoutDay: workoutDay,
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
