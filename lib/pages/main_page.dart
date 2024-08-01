
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
      ),
      body: SafeArea(
        child: Consumer<ExerciseList>(
          builder: (context, exerciseList, child) {
            if(exerciseList.getAllExercises().isEmpty) {
              return const Center(child: Text('No exercises found'));
            }
            return ListView.builder(
              itemCount: exerciseList.getAllExercises().length,
              itemBuilder: (context, index) {
                return ExerciseCard(exercise: exerciseList.getAllExercises().elementAt(index));
              },
            );
          },
        ),
      ),
    );
  }
}
