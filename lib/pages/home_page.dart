import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/settings.dart';
import 'package:workout_buddy/model/workout_plan_manager.dart';
import 'package:workout_buddy/pages/exercise_list_page.dart';
import 'package:workout_buddy/pages/onboarding_page.dart';
import 'package:workout_buddy/pages/settings_page.dart';
import 'package:workout_buddy/pages/user_page.dart';
import 'package:workout_buddy/pages/workout_details_page.dart';
import 'package:workout_buddy/pages/workout_plan_manager_page.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';
import '../model/user_data.dart';
import '../model/workout_day.dart';
import '../utils.dart';
import 'main_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                _buildBackground(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16.0),
                    _buildStatsSection(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildUpcomingWorkoutsSection(context),
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
        const SizedBox(
          height: 50,
          width: 50,
          child: Placeholder(), // Replace with your logo
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
            Selector<WorkoutPlanManager, int>(
              selector: (_, manager) =>
                  manager.selectedPlan?.workoutDays
                      .map((day) => day.workouts.length)
                      .reduce((a, b) => a + b) ??
                  0,
              builder: (context, totalWorkouts, child) {
                return _buildStatCard(
                    title: 'Total Workouts', value: '$totalWorkouts');
              },
            ),
            const SizedBox(width: 16),
            Selector<UserData, double>(
              selector: (_, userData) => userData.weightHistory.isNotEmpty
                  ? userData.weightHistory.first.weight - userData.weight
                  : 0.0,
              builder: (context, caloriesBurned, child) {
                return _buildCalorieCard(caloriesBurned: caloriesBurned);
              },
            ),
            const SizedBox(width: 16),
            Consumer<Settings>(
              builder: (context, settings, child) {
                return _buildStatCard(
                    title: 'Total Distance',
                    value: "1000 ${settings.useMetric ? "km" : "mi"}");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 40), // Replace with your icon
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            return userData.name.isNotEmpty
                ? Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userData.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("${userData.age} yrs",
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(width: 16),
                      const Placeholder(
                          fallbackHeight: 50,
                          fallbackWidth: 50), // Replace with user image
                    ],
                  )
                : const Text("Please complete your profile");
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
            var todayString = convertNumberToWeekday(today.weekday);
            var todayWorkouts = workoutPlanManager.selectedPlan!.workoutDays
                .where((day) => day.dayName == todayString)
                .toList();

            if (todayWorkouts.isEmpty) {
              return const Text("No workouts planned for today");
            }

            return Column(
              children: todayWorkouts
                  .map((day) => GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkoutDetailsPage(
                                    workoutPlan:
                                        workoutPlanManager.selectedPlan!))),
                        child: Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 100,
                            child: Center(child: Text(day.dayName)),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const WorkoutPlannerPage())),
          child: const Text('Create New Workout Plan'),
        ),
      ],
    );
  }

  Widget _buildCalorieCard({required double caloriesBurned}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('Calories burned so far'),
          const SizedBox(height: 8.0),
          Text(caloriesBurned.toStringAsFixed(2),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final buttons = [
      {'text': 'Main Page', 'page': const MainPage()},
      {'text': 'User Page', 'page': const UserPage()},
      {'text': 'Workout Plan Manager', 'page': const WorkoutPlanManagerPage()},
      {'text': 'Onboarding', 'page': const OnboardingPage()},
      {'text': 'Exercise List Page', 'page': ExerciseListPage()},
      {'text': 'Settings', 'page': const SettingsPage()},
    ];
    return Column(
      children: buttons
          .map((button) => ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => button['page'] as Widget)),
              child: Text(button['text'] as String)))
          .toList(),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Opacity(
      opacity: 0.75,
      child: Image.asset(
        "lib/assets/images/backgrounds/weights.png",
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildUpcomingWorkoutsSection(BuildContext context) {
    var today = DateTime.now();
    var todayString = convertNumberToWeekday(today.weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Workouts",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full schedule
                },
                child: const Text("View All"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null ||
                workoutPlanManager.selectedPlan!.workoutDays.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No upcoming workouts",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add workout plan action
                      },
                      child: const Text("Create Workout Plan"),
                    ),
                  ],
                ),
              );
            }

            List<WorkoutDay> allWorkoutDays =
                workoutPlanManager.selectedPlan!.workoutDays;
            List<WorkoutDay> upcomingWorkouts = [];
            int currentIndex =
                allWorkoutDays.indexWhere((day) => day.dayName == todayString);

            for (int i = 1; i <= 2; i++) {
              int nextIndex = (currentIndex + i) % allWorkoutDays.length;
              upcomingWorkouts.add(allWorkoutDays[nextIndex]);
            }

            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: upcomingWorkouts.length,
                itemBuilder: (context, index) {
                  final workoutDay = upcomingWorkouts[index];
                  Set<String> primaryMuscles = {};
                  for (var workout in workoutDay.workouts) {
                    primaryMuscles.add(workout.primaryMuscles!.first);
                  }

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigate to workout details
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      workoutDay.dayName,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                primaryMuscles.join(' • ').toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${workoutDay.workouts.length} exercises',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
