import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/pages/favorites_page.dart';
import 'package:workout_buddy/pages/workout_planner_page.dart';
 import '../model/exercise.dart';
import '../model/exercise_list.dart';
import '../widgets/exercise_display_with_shadow.dart';
import '../widgets/filter_dropdown.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedLevel;
  String? selectedPrimaryMuscle;
  String? selectedCategory;

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        actions: [
          FilterDropdown(
            hintText: 'Select Level',
            value: selectedLevel,
            options: difficultyLevels,
            onChanged: (String? newValue) {
              setState(() {
                selectedLevel = newValue;
              });
            },
          ),
          const SizedBox(width: 16.0),
          FilterDropdown(
            hintText: 'Select Muscle',
            value: selectedPrimaryMuscle,
            options: primaryMuscles,
            onChanged: (String? newValue) {
              setState(() {
                selectedPrimaryMuscle = newValue;
              });
            },
          ),
          const SizedBox(width: 16.0),
          FilterDropdown(
            hintText: 'Select Category',
            value: selectedCategory,
            options: categories,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selectedPage,
          children: [
            _buildWorkoutPage(),
            const FavoritesPage(),
            const WorkoutPlannerPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (int index) {
          setState(() {
            selectedPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Workout Planner',
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPage() {
    return Consumer<ExerciseList>(
      builder: (context, exerciseList, child) {
        Set<Exercise> exercises = exerciseList.getAllExercises();

        // Apply filters
        if (selectedLevel != null) {
          exercises = exercises
              .where((exercise) => exercise.level == selectedLevel)
              .toSet();
        }

        if (selectedPrimaryMuscle != null) {
          exercises = exercises
              .where((exercise) =>
                  exercise.primaryMuscles?.first == selectedPrimaryMuscle)
              .toSet();
        }

        if (selectedCategory != null) {
          exercises = exercises
              .where((exercise) => exercise.category == selectedCategory)
              .toSet();
        }

        return exercises.isEmpty
            ? const Center(child: Text('No exercises found'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return GridTile(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: ExerciseDisplayWithShadow(
                        exercise: exercises.elementAt(index),
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16.0),
              );
      },
    );
  }
}
