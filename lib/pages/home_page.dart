import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/workout_plan_manager.dart';
import 'package:workout_buddy/pages/user_page.dart';
import 'package:workout_buddy/pages/workout_details_page.dart';
import 'package:workout_buddy/pages/workout_plan_manager_page.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';
import 'package:workout_buddy/utils.dart';

import '../model/exercise.dart';
import '../model/user_data.dart';
import 'main_page.dart';

// Dummy exercises for testing
final exercises = [
  Exercise(name: '3/4 Sit-Up', images: ['lib/data/3_4_Sit-Up/0.jpg']),
  Exercise(name: '90/90 Hamstring', images: ['lib/data/90_90_Hamstring/0.jpg']),
  Exercise(
      name: 'Ab Crunch Machine', images: ['lib/data/Ab_Crunch_Machine/0.jpg']),
  Exercise(name: 'Ab Roller', images: ['lib/data/Ab_Roller/0.jpg']),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              _buildStatsSection(),
              _buildRecentWorkoutsSection(context),
              _buildTodayWorkoutsSection(context),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                },
                child: const Text('Main Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserPage(),
                    ),
                  );
                },
                child: const Text('User Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutPlanManagerPage(),
                    ),
                  );
                },
                child: const Text('Workout Plan Manager'),
              ),
            ],
          ),
        ));
  }

  _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Placeholder(
          child: Text('Logo'),
        ),
        _buildUserCard(),
      ],
    );
  }

  _buildStatsSection() {
    return Column(
      children: [
        const Text('Stats'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(title: 'Total Workouts', value: '10'),
            const SizedBox(width: 16),
            _buildStatCard(title: 'Total Calories Burned', value: '1,000'),
            const SizedBox(width: 16),
            _buildStatCard(title: 'Total Distance', value: '1,000'),
          ],
        ),
      ],
    );
  }

  _buildRecentWorkoutsSection(BuildContext context) {
    Set<Exercise> recentExercises = {};
    // TODO: Get recent exercises from the database
    if (recentExercises.isNotEmpty) {
      final random = Random();
      final randomExercise =
          recentExercises.elementAt(random.nextInt(recentExercises.length));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Workouts",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          _buildWorkoutCard(
              exercise:
                  randomExercise), // Or any other widget to display the exercise
        ],
      );
    } else {
      // Dummy data for testing
      final random = Random();
      final randomExercise =
          exercises.elementAt(random.nextInt(exercises.length));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Workouts",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          _buildWorkoutCard(
              exercise:
                  randomExercise), // Or any other widget to display the exercise
        ],
      );
    }
  }

  _buildStatCard({required String title, required String value}) {
    // TODO: Display user's stats and goals if set

    return Column(
      children: [
        const Placeholder(
          child: Text("Icon"),
        ),
        Text(
          title,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _buildWorkoutCard({required Exercise exercise}) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                exercise.images!.elementAt(0),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Text(
                exercise.name!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildUserCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserData>(builder: (context, userData, child) {
          if (userData.name.isEmpty) {
            return const Text("Please complete your profile");
          }
          return Row(
            children: [
              Column(
                children: [
                  Text(userData.name),
                  const SizedBox(height: 8),
                  // TODO setup secondary text style
                  Text("${userData.age} yrs"),
                ],
              ),
              const SizedBox(width: 16),
              const Placeholder(
                child: Text("user Profile Picture"),
              ),
            ],
          );
        }),
      ),
    );
  }

  _buildTodayWorkoutsSection(BuildContext context) {
    return Column(
      children: [
        const Text('Today\'s Workouts'),
        const SizedBox(height: 16.0),
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null) {
              return const Text("Please select a workout plan");
            }
            //   Match today with corresponding workout days
            var today = DateTime.parse(DateTime.now().toString());
            String stringfiedToday = convertNumberToWeekday(today.weekday);
            // debugPrint("Today: $stringfiedToday");
            // debugPrint("Workout days: ${workoutPlanManager.selectedPlan!.workoutDays.map((day) => day.dayName)}");

            // TODO Check if display correctly Seg - Quarta

            return Column(
              children:
                  workoutPlanManager.selectedPlan!.workoutDays.where((day) {
                return day.dayName == stringfiedToday;
              }).map((day) {
                // debugPrint("Day: $day");
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailsPage(
                          workoutPlan: workoutPlanManager.selectedPlan!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(child: Text(day.dayName)),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutPlannerPage(),
              ),
            );
          },
          child: const Text('Create New Workout Plan'),
        )
      ],
    );
  }
}
