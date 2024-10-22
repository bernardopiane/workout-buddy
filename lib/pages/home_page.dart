import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/exercise_filters.dart';
import 'package:workout_buddy/model/workout_plan_manager.dart';
import 'package:workout_buddy/pages/exercise_list_page.dart';
import 'package:workout_buddy/pages/onboarding_page.dart';
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
            // _buildNextWorkoutsSection(context),
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
        Text("Upcoming Workouts",
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16.0),
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null) {
              return const Text("Please select a workout plan");
            }

            var today = DateTime.now();
            var todayString = convertNumberToWeekday(today.weekday);

            var nextWorkoutDay =
                workoutPlanManager.selectedPlan!.workoutDays.firstWhere(
              (day) => day.dayName == todayString || day.workouts.isNotEmpty,
              orElse: () => workoutPlanManager.selectedPlan!.workoutDays.first,
            );

            if (nextWorkoutDay.workouts.isEmpty) {
              return const Text("No workouts planned for today");
            }

            var muscles = nextWorkoutDay.workouts
                .map((workout) => workout.images![0])
                .toSet()
                .toList();
            return Container();
            // return SizedBox(height: 256, child: MuscleOverlay(muscles));
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
          width: 50,
          child: Placeholder(), // Replace with your icon
        ),
        Text(title),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
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
                      const Placeholder(fallbackHeight: 50, fallbackWidth: 50),
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
              children: todayWorkouts.map((day) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailsPage(
                          workoutPlan: workoutPlanManager.selectedPlan!),
                    ),
                  ),
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

  Widget _buildCalorieCard({required double caloriesBurned}) {
    return Column(
      children: [
        const Text('Calories burned so far'),
        const SizedBox(height: 16.0),
        Text(caloriesBurned.toStringAsFixed(2),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final buttons = [
      {'text': 'Main Page', 'page': const MainPage()},
      {'text': 'User Page', 'page': const UserPage()},
      {'text': 'Workout Plan Manager', 'page': const WorkoutPlanManagerPage()},
      {'text': 'Onboarding', 'page': const OnboardingPage()},
      {
        'text': 'Exercise List Page',
        'page': ExerciseListPage(),
      },
    ];

    return Column(
      children: buttons.map((button) {
        return ElevatedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => button['page'] as Widget)),
          child: Text(button['text'] as String),
        );
      }).toList(),
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

  _buildUpcomingWorkoutsSection(BuildContext context) {
    const workoutToDisplay = 2;

    // Gets the next X workouts days from the workout plan manager based on the current date
    var today = DateTime.now();
    var todayString = convertNumberToWeekday(today.weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upcoming Workouts",
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16.0),

        // Use Consumer to access the WorkoutPlanManager data
        Consumer<WorkoutPlanManager>(
          builder: (context, workoutPlanManager, child) {
            if (workoutPlanManager.selectedPlan == null ||
                workoutPlanManager.selectedPlan!.workoutDays.isEmpty) {
              return const Text("No upcoming workouts.");
            }

            // Find the index of today in the workoutDays list
            List<WorkoutDay> allWorkoutDays =
                workoutPlanManager.selectedPlan!.workoutDays;

            // Get upcoming workouts starting from today
            List<WorkoutDay> upcomingWorkouts = [];
            int currentIndex =
                allWorkoutDays.indexWhere((day) => day.dayName == todayString);

            // Collect the next 2 upcoming workout days (wrap around if necessary)
            for (int i = 0; i < workoutToDisplay; i++) {
              int nextIndex = (currentIndex + i) % allWorkoutDays.length;
              upcomingWorkouts.add(allWorkoutDays[nextIndex]);
            }

            return Row(
                children: upcomingWorkouts.map((workoutDay) {
              // Get the primary muscles being worked on for this workout day
              Set<String> primaryMuscles = {};

              for (var workout in workoutDay.workouts) {
                primaryMuscles.add(workout.primaryMuscles!.first);
              }

              return Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workoutDay.dayName),
                        const SizedBox(height: 8),
                        Text(primaryMuscles.join(', ').toUpperCase(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList());
          },
        ),
      ],
    );
  }
}

/*

class MuscleOverlay extends StatelessWidget {
  final List<String> images;

  const MuscleOverlay(this.images, {super.key});

  // TODO Fix image scaling

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: DiagonalClipper(isLeft: true),
              child: Image.asset(
                "lib/data/${images[0]}",
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: DiagonalClipper(isLeft: false),
              child: Image.asset(
                "lib/data/${images[1]}",
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalSeparatorPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  final bool isLeft;

  DiagonalClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    Path path = Path();

    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.6, 0);
      path.lineTo(size.width * 0.4, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.6, 0);
      path.lineTo(size.width * 0.4, size.height);
      path.lineTo(size.width, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DiagonalSeparatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.4, size.height),
      Offset(size.width * 0.6, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
*/
