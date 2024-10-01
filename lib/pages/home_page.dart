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
              return nextWorkoutDay;
            });

            if (nextWorkoutDay.workouts.isEmpty) {
              return const Text("No workouts planned for today");
            }

            //Return the next workout day primary muscle being worked on with no duplicates
            // To Set to remove duplicates
            // nextWorkoutDay.workouts
            //                     .map((workout) => _buildMuscleDisplay(workout.images![0]))
            //                     .toSet()
            //                     .toList(),

            List<String> muscles = nextWorkoutDay.workouts
                .map((workout) => workout.images![0])
                .toSet()
                .toList();

            return SizedBox(height: 128, child: MuscleOverlay(muscles));
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

  Widget _buildMuscleDisplay(String imagePath) {
    debugPrint("Muscle: $imagePath");
    return Image.asset(
      "lib/data/$imagePath",
      fit: BoxFit.cover,
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

  /*Widget _buildMuscleOverlay(List<String> list, BuildContext context) {
    //   Return a Pill shaped container with two exercises images

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            //   First image on the left
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "lib/data/${list[0]}",
                height: 256,
                width: MediaQuery.of(context).size.width / 2,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),

            //Second image on the right
            Positioned(
              top: 0,
              // Left 50% of the screen
              left: MediaQuery.of(context).size.width / 2,
              // Right: 0 does not work as intended
              child: Image.asset(
                "lib/data/${list[1]}",
                height: 256,
                width: MediaQuery.of(context).size.width / 2,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),

            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2.75, // Adjust for separator width
              child: Transform.rotate(
                angle: 0.785398, // 45 degrees in radians
                child: Container(
                  width: 16, // Adjust width based on need
                  height: 256, // Height should match image height
                  color: Colors.white, // Separator color (can be changed)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}

class DiagonalClipper extends CustomClipper<Path> {
  final bool isLeft;

  DiagonalClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    Path path = Path();

    if (isLeft) {
      // Left section
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.6000000, 0);
      path.lineTo(size.width * 0.4000000, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Right section
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.6000000, 0);
      path.lineTo(size.width * 0.4000000, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MuscleOverlay extends StatelessWidget {
  final List<String> images;

  const MuscleOverlay(this.images, {super.key});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50), // Pill shaped container
      child: SizedBox(
        height: 256,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // Left diagonal clipped image
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
            // Right diagonal clipped image
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
            // Diagonal separator (angled line)
            Positioned.fill(
              child: CustomPaint(
                painter: DiagonalSeparatorPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalSeparatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw diagonal line
    canvas.drawLine(
      Offset(size.width * 0.4000000, size.height),
      Offset(size.width * 0.6000000, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
