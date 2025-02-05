import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/model/user_data.dart';

import '../../providers/workout_plan_manager.dart';
import '../../utils/date_utils.dart';
import '../user_page.dart';

class HomePageV2 extends StatelessWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 16.0),
            _buildTodayCard(context),
            SizedBox(height: 16.0),
            _buildSchedule(context),
          ],
        ),
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserPage(),
              ),
            );
          },
          child: userData.name.isNotEmpty
              ? Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 50,
                      child: Text(userData.name.substring(0, 1).toUpperCase()),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back, ${userData.name}!",
                            style: Theme.of(context).textTheme.headlineLarge),
                        Text("Your workout progress",
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ],
                )
              : const Text("Please complete your profile"),
        );
      },
    );
  }

  _buildTodayCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<WorkoutPlanManager>(
            builder: (context, workoutPlanManager, child) {
          int exerciseTime = 0;
          Set<String> primaryMuscles = {};
          Set<String> category = {};

          // TODO Calculate the exercise time and calories burned

          //   If there is not selected plan, allow the user to select one
          if (workoutPlanManager.selectedPlan == null) {
            // TODO Implement the logic to select a workout plan
            return Container();
          } else {
            //   Get today's workouts
            var today = DateTime.now();
            var todayString = convertNumberToWeekday(today.weekday);
            var todayWorkouts = workoutPlanManager.selectedPlan!.workoutDays
                .where((day) => day.dayName == todayString)
                .toList();

            // Calculate the total exercise time
            for (var workoutDay in todayWorkouts) {
              for (var workout in workoutDay.workouts) {
                // Each exercise takes approximately 15 minutes
                exerciseTime += 15;
                primaryMuscles.addAll(workout.primaryMuscles!);
                category.add(workout.category!);
              }
            }
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "lib/assets/images/Dumbbell.png",
                    // TODO Adjust sizes
                    height: 48,
                    width: 48,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // TODO adjust padding and spacing
                      Text("Today's Gym Session",
                          style: Theme.of(context).textTheme.headlineSmall),
                      // TODO display the primary muscles targeted adjust sizing and colors
                      Text(primaryMuscles.join(' • ').toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO Calculate based on the day's workout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Duration"),
                      Text("Approx. ${exerciseTime.toStringAsFixed(0)} mins"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Calories burned"),
                      Text("1,000"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Workout type"),
                      Text(category.join(' • ').toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  _buildSchedule(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your schedule for:",
                style: Theme.of(context).textTheme.headlineLarge),
            _buildDayPicker(),
          ],
        )
      ],
    );
  }

  // TODO Extract into a new file/widget
  _buildDayPicker() {
    String? selectedDay;

    return DropdownMenu<String>(
      initialSelection: "Today",
      onSelected: (String? day) {
        selectedDay = day;
      },
      dropdownMenuEntries:
          daysOfWeek.map<DropdownMenuEntry<String>>((String day) {
        return DropdownMenuEntry<String>(value: day, label: day);
      }).toList(),
    );
  }
}
