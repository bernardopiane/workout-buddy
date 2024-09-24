import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/workout_plan_manager.dart';
import 'package:workout_buddy/pages/onboarding_page.dart';
import 'package:workout_buddy/pages/user_page.dart';
import 'package:workout_buddy/pages/workout_details_page.dart';
import 'package:workout_buddy/pages/workout_plan_manager_page.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';
import '../model/exercise.dart';
import '../model/user_data.dart';
import '../utils.dart';
import 'main_page.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16.0),
            _buildStatsSection(),
            const SizedBox(height: 16.0),
            _buildNextWorkoutsSection(context),
            const SizedBox(height: 16.0),
            _buildTodayWorkoutsSection(context),
            const SizedBox(height: 16.0),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Placeholder(
          fallbackHeight: 50,
          fallbackWidth: 50,
          child: Text('Logo'),
        ),
        _buildUserCard(),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(title: 'Total Workouts', value: '10'),
            const SizedBox(width: 16),
            Consumer<UserData>(
              builder: (context, userData, child) {
                return _buildCalorieCard(userData: userData);
              },
            ),
            const SizedBox(width: 16),
            _buildStatCard(title: 'Total Distance', value: '1,000 km'),
          ],
        ),
      ],
    );
  }

  Widget _buildNextWorkoutsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Next Workouts",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16.0),
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null) {
              return const Text("Please select a workout plan");
            }

            var today = DateTime.now();
            String todayString = convertNumberToWeekday(today.weekday);
            debugPrint("Today string: $todayString");

            // Get the next workout day using todayString
            // Check if today has a workout day
            // If not, then look for the next workout day
            var nextWorkoutDay = workoutPlanManager.selectedPlan!.workoutDays
                .firstWhere((day) => day.dayName == todayString, orElse: () {
              // If today has no workout day, look for the next workout day
              var nextWorkoutDay = workoutPlanManager.selectedPlan!.workoutDays
                  .firstWhere((day) => day.dayName != todayString);
              debugPrint("Next workout day: $nextWorkoutDay");
              return nextWorkoutDay;
            });

            if (nextWorkoutDay.workouts.isEmpty) {
              return const Text("No workouts planned for today");
            }

            //Return the next workout day primary muscle being worked on with no duplicates
            // To Set to remove duplicates
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: nextWorkoutDay.workouts
                  .map((workout) =>
                      _buildMuscleDisplay(workout.primaryMuscles![0]))
                  .toSet()
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Column(
      children: [
        const Placeholder(
          fallbackHeight: 50,
          fallbackWidth: 50,
          child: Text("Icon"),
        ),
        Text(title),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard({required Exercise exercise}) {
    return Card(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Positioned.fill(
              child: exercise.images != null && exercise.images!.isNotEmpty
                  ? Image.asset(
                      exercise.images![0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                            color: Colors.grey); // Placeholder for error
                      },
                    )
                  : Container(color: Colors.grey), // Placeholder if no image
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
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserData>(
          builder: (context, userData, child) {
            if (userData.name.isEmpty) {
              return const Text("Please complete your profile");
            }
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("${userData.age} yrs",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(width: 16),
                const Placeholder(fallbackHeight: 50, fallbackWidth: 50),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTodayWorkoutsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today\'s Workouts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16.0),
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null) {
              return const Text("Please select a workout plan");
            }

            var today = DateTime.now();
            String todayString = convertNumberToWeekday(today.weekday);

            var todayWorkouts =
                workoutPlanManager.selectedPlan!.workoutDays.where((day) {
              return day.dayName == todayString;
            }).toList();

            if (todayWorkouts.isEmpty) {
              return const Text("No workouts planned for today");
            }

            return Column(
              children: todayWorkouts.map((day) {
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
                  builder: (context) => const WorkoutPlannerPage()),
            );
          },
          child: const Text('Create New Workout Plan'),
        ),
      ],
    );
  }

  Widget _buildCalorieCard({required UserData userData}) {
    double caloriesBurned = userData.weightHistory.isNotEmpty
        ? userData.weightHistory.first.weight - userData.weight
        : 0.0;

    return Column(
      children: [
        const Text('Calories burned so far'),
        const SizedBox(height: 16.0),
        Text(
          caloriesBurned.toStringAsFixed(2),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
          child: const Text('Main Page'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserPage()),
            );
          },
          child: const Text('User Page'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const WorkoutPlanManagerPage()),
            );
          },
          child: const Text('Workout Plan Manager'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
            );
          },
          child: const Text('Onboarding'),
        ),
      ],
    );
  }

  // TODO: add muscle images
  Widget _buildMuscleDisplay(String s) {
    return const Placeholder(
      fallbackHeight: 50,
      fallbackWidth: 150,
      color: Colors.grey,
    );

    return Image.asset(
      "lib/assets/images/muscle_${s.toLowerCase()}.png",
      fit: BoxFit.contain,
    );
  }
}
