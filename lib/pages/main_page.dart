import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/widgets/exercise_card.dart';
import '../model/exercise.dart';
import '../model/exercise_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
      ),
      body: SafeArea(
        child: Consumer<ExerciseList>(
          builder: (context, exerciseList, child) {
            Set<Exercise> exercises = exerciseList.getAllExercises();
            return exercises.isEmpty
                ? const Center(child: Text('No exercises found'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      // childAspectRatio: 0.75,
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
