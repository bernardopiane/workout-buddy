import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/settings.dart';
import 'package:workout_buddy/pages/home/home_v3.dart';
import 'package:workout_buddy/providers/workout_plan_manager.dart';
import 'package:workout_buddy/pages/exercise_list_page.dart';
import 'package:workout_buddy/pages/onboarding_page.dart';
import 'package:workout_buddy/pages/settings_page.dart';
import 'package:workout_buddy/pages/user_page.dart';
import 'package:workout_buddy/pages/workout_day_page.dart';
import 'package:workout_buddy/pages/workout_details_page.dart';
import 'package:workout_buddy/pages/workout_plan_manager_page.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';
import '../model/user_data.dart';
import '../model/workout_day.dart';
import '../model/workout_plan.dart';
import '../utils/date_utils.dart';
import 'home/home_v4.dart';
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
            // const SizedBox(width: 16),
            // Selector<UserData, double>(
            //   selector: (_, userData) => userData.weightHistory.isNotEmpty
            //       ? userData.weightHistory.first.weight - userData.weight
            //       : 0.0,
            //   builder: (context, caloriesBurned, child) {
            //     return _buildStatCard(
            //         title: 'Calories Burned',
            //         value: caloriesBurned.toStringAsFixed(0));
            //     // return _buildCalorieCard(caloriesBurned: caloriesBurned, context: context);
            //   },
            // ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // TODO Play around with shadows and colors
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Today\'s Workouts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('E, MMM d').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<WorkoutPlanManager>(
            builder: (context, workoutPlanManager, child) {
              if (workoutPlanManager.selectedPlan == null) {
                return _buildEmptyState(
                  icon: Icons.fitness_center,
                  title: "No Workout Plan Selected",
                  subtitle: "Create or select a workout plan to get started",
                  context: context,
                );
              }

              var today = DateTime.now();
              var todayString = convertNumberToWeekday(today.weekday);
              var todayWorkouts = workoutPlanManager.selectedPlan!.workoutDays
                  .where((day) => day.dayName == todayString)
                  .toList();

              if (todayWorkouts.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.wb_sunny_outlined,
                  title: "Rest Day",
                  subtitle: "Take it easy today or try a recovery workout",
                  context: context,
                );
              }

              return Column(
                children: todayWorkouts
                    .map((day) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildWorkoutCard(
                              context, day, workoutPlanManager.selectedPlan!),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkoutPlannerPage()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Plan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
      BuildContext context, WorkoutDay day, WorkoutPlan plan) {
    // TODO Display a summary of the workouts in the card
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsPage(workoutPlan: plan),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  // TODO: Calculate what type of workout it being worked on (strength, plyometrics, etc.) and display the appropriate icon
                  _getWorkoutIcon(day.workouts.first.category),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: Display the summary of the workouts in the card
                    Text(
                      day.workouts.first.name ?? 'Workout',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.workouts.length} exercises',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getWorkoutIcon(String? workoutType) {
    switch (workoutType?.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.self_improvement;
      case 'hiit':
        return Icons.timer;
      default:
        return Icons.sports_gymnastics;
    }
  }

  Widget _buildCalorieCard({
    required BuildContext context,
    required double caloriesBurned,
    double? dailyGoal,
    String? lastUpdated,
  }) {
    final percentage = dailyGoal != null
        ? (caloriesBurned / dailyGoal * 100).clamp(0, 100)
        : null;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.1), // Light primary color
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calories Burned',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Icon(
                    Icons.local_fire_department,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    caloriesBurned.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (dailyGoal != null) ...[
                const SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage! / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 100
                          ? Theme.of(context).colorScheme.primary.withValues(
                              alpha: 0.8) // Assuming a success color is defined
                          : Theme.of(context)
                              .colorScheme
                              .primary, // Primary color for progress
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(1)}% of daily goal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '${dailyGoal.toStringAsFixed(0)} kcal',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ],
              if (lastUpdated != null) ...[
                const SizedBox(height: 12.0),
                Text(
                  'Last updated: $lastUpdated',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final buttons = [
      {'text': 'Home 2', 'page': const HomeV3()},
      {'text': 'Home 3', 'page': const HomeV4()},
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
                          // Navigate to workout day page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutDayPage(
                                exercises: workoutDay.workouts,
                              ),
                            ),
                          );
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
