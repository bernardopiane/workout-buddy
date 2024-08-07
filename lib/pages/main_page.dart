import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/global.dart';
import 'package:workout_buddy/widgets/exercise_card.dart';
import '../model/exercise.dart';
import '../model/exercise_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? selectedLevel;
  String? selectedPrimaryMuscle;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        actions: [
          // TODO Add ability to deselect filters
          DropdownButton<String>(
            value: selectedLevel,
            hint: const Text("Select Level"),
            onChanged: (String? newValue) {
              setState(() {
                selectedLevel = newValue;
              });
            },
            items:
                difficultyLevels.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value.toLowerCase(),
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(width: 16.0),
          DropdownButton<String>(
            value: selectedPrimaryMuscle,
            hint: const Text("Select Muscle"),
            onChanged: (String? newValue) {
              setState(() {
                selectedPrimaryMuscle = newValue;
              });
            },
            items: primaryMuscles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value.toLowerCase(),
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(width: 16.0),

          DropdownButton<String>(
            value: selectedPrimaryMuscle,
            hint: const Text("Select Category"),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value.toLowerCase(),
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: SafeArea(
        child: Consumer<ExerciseList>(
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return ExerciseCard(exercise: exercises.elementAt(index));
                    },
                    padding: const EdgeInsets.all(16.0),
                  );
          },
        ),
      ),
    );
  }
}
