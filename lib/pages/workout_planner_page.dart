import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/model/workout_day.dart';
import 'package:workout_buddy/model/workout_plan.dart';
import 'package:workout_buddy/pages/workout_details_page.dart';
import 'package:workout_buddy/widgets/workout_selector.dart';

import '../providers/workout_plan_manager.dart';
import '../utils/text_utils.dart';

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
            onStepTapped: _onStepTapped,
            controlsBuilder: _buildStepperControls,
            steps: _buildSteps(),
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return <Step>[
      Step(
        isActive: _index >= 0,
        title: const Text('Select Days'),
        content: _buildSelectDaysStep(),
      ),
      Step(
        isActive: _index >= 1,
        title: const Text('Select Workouts'),
        content: _buildSelectWorkoutsStep(),
      ),
      Step(
        isActive: _index == 2,
        title: const Text("Summary"),
        state: _index == 2 ? StepState.complete : StepState.disabled,
        content: _buildSummaryStep(),
      ),
    ];
  }

  Widget _buildSelectDaysStep() {
    return Wrap(
      children: daysOfWeek.map((e) {
        return CheckboxListTile(
          title: Text(e),
          value: workoutDays.any((element) => element.dayName == e),
          onChanged: (bool? value) => _onDaySelected(value, e),
        );
      }).toList(),
    );
  }

  Widget _buildSelectWorkoutsStep() {
    if (workoutDays.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Days Selected',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Add workout days to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: workoutDays.map((day) {
          final isSelected = day.workouts.isNotEmpty;

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => WorkoutSelector(
                  workoutDay: day,
                  addWorkout: _addWorkout,
                  removeWorkout: _removeWorkout,
                ),
              );
            },
            child: Material(
              elevation: isSelected ? 8 : 2,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.dayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isSelected)
                      Icon(
                        Icons.fitness_center,
                        size: 24,
                        color: Colors.white,
                      )
                    else
                      Text(
                        '${day.workouts.length} workouts',
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workoutDays
          .map((day) => Text(
              "${day.dayName}: ${getPrimaryMuscles(day).map((muscle) => capitalize(muscle)).join(', ')}"))
          .toList(),
    );
  }

  Widget _buildStepperControls(BuildContext context, ControlsDetails details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (details.stepIndex > 0)
          _buildStepperButton(
            context,
            label: "Previous",
            icon: Icons.arrow_back_rounded,
            onPressed: _onPreviousStep,
          ),
        if (details.stepIndex < 2)
          _buildStepperButton(
            context,
            label: "Next",
            icon: Icons.arrow_forward_rounded,
            isPrimary: true,
            onPressed: _onNextStep,
          ),
        if (details.stepIndex == 2)
          _buildStepperButton(
            context,
            label: "Complete",
            icon: Icons.check,
            isPrimary: true,
            onPressed: _onCompleteWorkout,
          ),
      ],
    );
  }

  ElevatedButton _buildStepperButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    final backgroundColor = isPrimary
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    final textColor = isPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _onStepTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  void _onPreviousStep() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
  }

  void _onNextStep() {
    if (_index < 2) {
      setState(() {
        _index += 1;
      });
    }
  }

  void _onCompleteWorkout() {
    final workoutPlan = Provider.of<WorkoutPlan>(context, listen: false);
    workoutPlan.setPlanName("Completed Workout");
    workoutPlan.setWorkoutDays(workoutDays);
    final workoutPlanManager = Provider.of<WorkoutPlanManager>(context, listen: false);
    workoutPlanManager.addWorkoutPlan(workoutPlan);
    resetSelections();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WorkoutDetailsPage(workoutPlan: workoutPlan),
    ));
  }

  void _onDaySelected(bool? value, String dayName) {
    setState(() {
      if (value == true) {
        workoutDays.add(WorkoutDay(dayName: dayName, workouts: []));
        // Reorder WorkoutDays to match the order of dayOfWeek
        List<String> dayOrder = daysOfWeek.toList();
        workoutDays.sort((a, b) {
          return dayOrder
              .indexOf(a.dayName)
              .compareTo(dayOrder.indexOf(b.dayName));
        });
      } else {
        workoutDays.removeWhere((element) => element.dayName == dayName);
      }
      _tabController = TabController(length: workoutDays.length, vsync: this);
    });
  }

  void _addWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .firstWhere((element) => element.dayName == workoutDay.dayName)
          .workouts
          .add(exercise);
    });
  }

  void _removeWorkout(WorkoutDay workoutDay, Exercise exercise) {
    setState(() {
      workoutDays
          .firstWhere((element) => element.dayName == workoutDay.dayName)
          .workouts
          .remove(exercise);
    });
  }

  Set<String> getPrimaryMuscles(WorkoutDay workoutDay) {
    Set<String> muscles = <String>{};
    for (Exercise exercise in workoutDay.workouts) {
      muscles.addAll(exercise.primaryMuscles!);
    }
    return muscles;
  }

  void resetSelections() {
    setState(() {
      _index = 0;
      _tabController = TabController(length: workoutDays.length, vsync: this);
      workoutDays = List.empty(growable: true);
    });
  }
}
